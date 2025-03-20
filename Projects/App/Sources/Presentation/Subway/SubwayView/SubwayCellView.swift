//
//  SubwayCellView.swift
//  App
//
//  Created by 윤제 on 3/12/25.
//

import Foundation
import SwiftUI

import Core

struct SubwayCellView: View {
    
    let arrivalTimes: [Int]
    let curretStation: String
    let nextStation: String
    let subwayId: String
    
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                
                HStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 3)
                            .foregroundColor(Color(uiColor: SubwayLine(rawValue: subwayId)?.color ?? .clear))
                            .frame(width: 25, height: 25)
                        Text(SubwayLine(rawValue: subwayId)?.name ?? "")
                            .font(.system(size: 20, weight: .semibold))
                        
                    }
                    Text(curretStation)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Spacer()
                Text("다음역")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
                Text(nextStation)
                    .font(.system(size: 15, weight: .semibold))
            }
            Spacer().frame(height: 32)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width - 4, y: 0)) // 원하는 길이로 조정
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [8, 3])) // 점선 스타일 적용
                    .foregroundColor(.gray.opacity(0.5)) // 선 색상
                    
                    ForEach(arrivalTimes, id: \.self) { ratio in
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color(uiColor: .recordColor.withAlphaComponent(0.8)))
                            .position(x: (1.0 - CGFloat(ratio) / CGFloat(500.0)) * geometry.size.width, y: 0)
                    }
                    
                    // 오른쪽 끝 동그라미
                    Circle()
                        .stroke(lineWidth: 3.5)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.green)
                        .position(x: geometry.size.width + 2, y: 0) // 약간의 offset 추가
                }
            }
            
            Spacer().frame(height: 28)
            
            Text("도착예정 ")
                .font(.system(size: 17, weight: .regular)) +
            Text(formattedTimeString(from: arrivalTimes[0]))
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(Color(uiColor: .recordColor)) +
            Text(" 후")
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
                .frame(height: 3)
            
            Text("다음열차 \(arrivalTimes.count > 1 ? "약 " + formattedTimeString(from: arrivalTimes[1]) + " 후" : "도착정보 없음")")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.05))
        .frame(height: 150)
        .cornerRadius(12)
    }
}

// MARK: -
extension SubwayCellView {
    func formattedTimeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        
        if remainingSeconds == 0 {
            return "\(minutes)분"
        } else if minutes > 0 {
            return "\(minutes)분 \(remainingSeconds)초"
        } else {
            return "\(remainingSeconds)초"
        }
    }
}

