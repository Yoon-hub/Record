//
//  CoinFlipView.swift
//  App
//
//  Created by Cursor on 4/1/26.
//

import SwiftUI
import UIKit

import Design

struct CoinFlipView: View {
    private enum TossStyle: CaseIterable {
        case arc
        case snap
        case bounce
        case float
    }
    
    private enum CoinSide: String {
        case heads = "앞"
        case tails = "뒷"
        
        var subtitle: String {
            switch self {
            case .heads: return "앞"
            case .tails: return "뒷"
            }
        }
    }
    
    @State private var result: CoinSide = .heads
    @State private var isAnimating = false
    
    @State private var coinRotation: Double = 0
    @State private var coinTilt: Double = 0
    @State private var coinYOffset: CGFloat = 0
    
    @State private var chargeProgress: Double = 0
    @State private var isCharging = false
    @State private var chargeStartDate: Date?
    @State private var chargeTimer: Timer?
    
    private let maxChargeDuration: Double = 1.8
    
    private var visibleSide: CoinSide {
        let normalized = coinRotation.truncatingRemainder(dividingBy: 360)
        let adjusted = normalized >= 0 ? normalized : normalized + 360
        return (90..<270).contains(adjusted) ? .tails : .heads
    }
    
    private var edgeThickness: CGFloat {
        let radians = coinRotation * .pi / 180
        let sideFactor = abs(sin(radians))
        return max(3, 16 * sideFactor)
    }
    
    private var edgeOpacity: Double {
        let radians = coinRotation * .pi / 180
        let sideFactor = abs(sin(radians))
        return 0.2 + (0.55 * sideFactor)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.97, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                coinCard
                actionButton
            } 
            .padding(.horizontal, 16)
            .padding(.top, 6)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("동전 던지기")
        .onDisappear {
            stopChargingTimer()
        }
    }
    
    private var coinCard: some View {
        VStack(spacing: 18) {
            Spacer()
            ZStack {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.86, green: 0.87, blue: 0.90),
                                Color(red: 0.75, green: 0.77, blue: 0.82),
                                Color(red: 0.86, green: 0.87, blue: 0.90)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: edgeThickness, height: 188)
                    .opacity(edgeOpacity)
                
                coinFace(side: .heads)
                    .opacity(visibleSide == .heads ? 1 : 0)
                    
                coinFace(side: .tails)
                    .opacity(visibleSide == .tails ? 1 : 0)
            }
            .rotation3DEffect(.degrees(coinRotation), axis: (x: 0, y: 1, z: 0), perspective: 0.7)
            .rotation3DEffect(.degrees(coinTilt), axis: (x: 1, y: 0, z: 0), perspective: 0.5)
            .offset(y: coinYOffset)
            
            Text("\(result.subtitle)")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(red: 0.20, green: 0.22, blue: 0.27))
            
            Text(isAnimating ? "동전이 회전 중입니다" : "버튼을 누르면 다시 던집니다")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(red: 0.45, green: 0.48, blue: 0.54))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 320)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    private var actionButton: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    isAnimating
                    ? Color(red: 0.87, green: 0.88, blue: 0.90)
                    : Color(red: 0.58, green: 0.75, blue: 0.99)
                )
                .frame(height: 54)
                
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 0.45, green: 0.66, blue: 0.96))
                .frame(width: max(0, (UIScreen.main.bounds.width - 32) * chargeProgress), height: 54)
                .opacity(isAnimating ? 0 : 1)
            
            Text(isAnimating ? "던지는 중..." : (isCharging ? "힘 모으는 중..." : "꾹 눌러 던지기"))
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard !isAnimating else { return }
                    if !isCharging {
                        startCharging()
                    }
                }
                .onEnded { _ in
                    guard !isAnimating else { return }
                    releaseAndFlip()
                }
        )
        .opacity(isAnimating ? 0.85 : 1)
    }
    
    private func coinFace(side: CoinSide) -> some View {
        ZStack {
            Image(uiImage: side == .heads ? DesignAsset.coinFront.image : DesignAsset.coinBack.image)
                .resizable()
                .scaledToFit()
                .frame(width: 156, height: 156)
                .clipShape(Circle())
                .padding(16)
                .background(
                    Circle()
                        .fill(Color(red: 0.95, green: 0.96, blue: 0.98))
                )
                .overlay(Circle().stroke(Color(red: 0.86, green: 0.88, blue: 0.92), lineWidth: 2))
                .shadow(color: Color(red: 0.56, green: 0.60, blue: 0.68).opacity(0.22), radius: 12, y: 8)
        }
        .frame(width: 188, height: 188)
    }
    
    private func currentHalfTurns() -> Int {
        Int((coinRotation / 180).rounded())
    }
    
    private func sideAt(halfTurns: Int) -> CoinSide {
        halfTurns.isMultiple(of: 2) ? .heads : .tails
    }
    
    private func halfTurnDeltaToReach(_ target: CoinSide, from current: Int) -> Int {
        let currentSide = sideAt(halfTurns: current)
        return currentSide == target ? 0 : 1
    }
    
    private func resetMicroMotion() {
        coinTilt = 0
        coinYOffset = 0
    }
            
    private func startCharging() {
        guard !isAnimating else { return }
        isCharging = true
        chargeProgress = 0
        chargeStartDate = Date()
        stopChargingTimer()
        triggerImpact(style: .light)
        
        chargeTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            guard let start = chargeStartDate else { return }
            let elapsed = Date().timeIntervalSince(start)
            chargeProgress = min(1, elapsed / maxChargeDuration)
        }
    }
    
    private func stopChargingTimer() {
        chargeTimer?.invalidate()
        chargeTimer = nil
    }
    
    private func releaseAndFlip() {
        let power = chargeProgress
        isCharging = false
        stopChargingTimer()
        chargeStartDate = nil
        triggerImpact(style: .medium)
        chargeProgress = 0
        flipCoin(power: power)
    }
    
    private func flipCoin(power: Double) {
        guard !isAnimating else { return }
        isAnimating = true
        
        let targetSide: CoinSide = Bool.random() ? .heads : .tails
        let current = currentHalfTurns()
        let minHalfTurns = 4
        let maxHalfTurns = 26
        let scaledTurns = Double(minHalfTurns) + (Double(maxHalfTurns - minHalfTurns) * power)
        let extraHalfTurns = Int(scaledTurns.rounded()) + Int.random(in: 0...1)
        let parityFix = halfTurnDeltaToReach(targetSide, from: current + extraHalfTurns)
        let totalHalfTurns = extraHalfTurns + parityFix
        
        // Keep angular speed constant; only turn count changes by power.
        let secondsPerHalfTurn = 0.10
        let duration = max(0.45, Double(totalHalfTurns) * secondsPerHalfTurn)
        let style = TossStyle.allCases.randomElement() ?? .arc
        let tiltValue = Double.random(in: -24...24)
        
        switch style {
        case .arc:
            withAnimation(.easeOut(duration: duration * 0.34)) {
                coinYOffset = CGFloat.random(in: -48 ... -26)
                coinTilt = tiltValue
            }
            withAnimation(.interpolatingSpring(stiffness: 180, damping: 13).delay(duration * 0.34)) {
                coinYOffset = 0
            }
            
        case .snap:
            withAnimation(.easeIn(duration: duration * 0.16)) {
                coinYOffset = CGFloat.random(in: -28 ... -16)
                coinTilt = tiltValue * 1.2
            }
            withAnimation(.easeOut(duration: duration * 0.20).delay(duration * 0.16)) {
                coinYOffset = 0
            }
            
        case .bounce:
            withAnimation(.easeOut(duration: duration * 0.26)) {
                coinYOffset = CGFloat.random(in: -42 ... -24)
                coinTilt = tiltValue * 0.8
            }
            withAnimation(.interpolatingSpring(stiffness: 240, damping: 10).delay(duration * 0.26)) {
                coinYOffset = 0
            }
            
        case .float:
            withAnimation(.easeInOut(duration: duration * 0.45)) {
                coinYOffset = CGFloat.random(in: -36 ... -20)
                coinTilt = tiltValue * 0.6
            }
            withAnimation(.easeInOut(duration: duration * 0.45).delay(duration * 0.45)) {
                coinYOffset = 0
            }
        }
        
        withAnimation(.easeInOut(duration: duration)) {
            coinRotation += Double(totalHalfTurns) * 180
        }
        
        withAnimation(.easeOut(duration: duration * 0.45).delay(duration * 0.55)) {
            coinTilt = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            result = targetSide
            resetMicroMotion()
            isAnimating = false
        }
    }
    
    private func triggerImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

