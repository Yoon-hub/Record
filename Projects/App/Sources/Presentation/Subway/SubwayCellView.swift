//
//  SubwayCellView.swift
//  App
//
//  Created by 윤제 on 3/12/25.
//

import Foundation

import SwiftUI

struct SubwayCellView: View {
    
    let arrivalTimes: [CGFloat]
    let curretStation: String
    let nextStation: String
    let subwayId: String
    
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                Text("신대방")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Text("다음역")
                    .font(.system(size: 15, weight: .regular))
                Text("구로디지털단지")
                    .font(.system(size: 15, weight: .semibold))
            }
            Spacer().frame(height: 32)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: 0)) // 원하는 길이로 조정
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [8, 3])) // 점선 스타일 적용
                    .foregroundColor(.gray.opacity(0.5)) // 선 색상
                    
                    ForEach(arrivalTimes, id: \.self) { ratio in
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.green)
                            .position(x: geometry.size.width * ratio, y: 0)
                    }
                    
                    // 오른쪽 끝 동그라미
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.green)
                        .position(x: geometry.size.width + 4, y: 0) // 약간의 offset 추가
                }
            }
            
            Spacer().frame(height: 28)
            
            Text("도착예정 1분 12초 후")
                .font(.system(size: 19, weight: .regular))
            Text("다음 열차 약 3분 후")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.05))
        .frame(height: 150)
        .cornerRadius(12)
    }
}

