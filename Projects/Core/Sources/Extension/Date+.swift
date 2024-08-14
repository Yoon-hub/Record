//
//  Date+.swift
//  Core
//
//  Created by 윤제 on 7/30/24.
//

import Foundation

public extension Date {
    // 날짜를 "2024.04.03" 형태로 포맷팅하는 함수
    func formattedDateString() -> String {
        // DateFormatter 인스턴스 생성
        let dateFormatter = DateFormatter()
        
        // 날짜 형식 설정
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        // 현재 날짜를 문자열로 변환
        return dateFormatter.string(from: self)
    }
    
    func formatToMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        return formatter.string(from: self)
    }
    
    func formatToYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = ".YYYY"
        return formatter.string(from: self)
    }
}
