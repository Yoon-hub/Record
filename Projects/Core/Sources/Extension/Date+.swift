//
//  Date+.swift
//  Core
//
//  Created by 윤제 on 7/30/24.
//

import Foundation

public extension Date {
    // 날짜를 "2024.04.03" 형태로 포맷팅하는 함수
    
    enum DateFormat: String {
        case yearMonthDay = "yyyy.MM.dd"
        case yearMonthDayWeek = "yyyy년 M월 d일(EEEE)"
    }
    
    func formattedDateString(type: DateFormat) -> String {
        // DateFormatter 인스턴스 생성
        let dateFormatter = DateFormatter()
        
        
        switch type {
        case .yearMonthDay:
            dateFormatter.dateFormat = "yyyy.MM.dd"
        case .yearMonthDayWeek:
            dateFormatter.dateFormat = "yyyy년 M월 d일(E)"
        }
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
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
    
    func formatToTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: self)
    }
    
    func surroundingYears() -> [String] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: self)
        
        let previousYear = currentYear - 1
        let nextYear = currentYear + 1
        
        return ["\(previousYear)", "\(currentYear)", "\(nextYear)"]
    }
}
