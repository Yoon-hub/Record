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
        case yearMonthDayTime = "M월 d일 (E)\nHH:mm"
        case yearMonthDayTime2 = "M월 d일 (E) HH:mm"
        case simpleMonthDay = "M.d(E)"
        
        // 카카오톡 공유에 사용
        case simpleDate = "MM.dd(E) H:mm"
    }
    
    func formattedDateString(type: DateFormat) -> String {
        // DateFormatter 인스턴스 생성
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = type.rawValue
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
    
    func formatToTime24Hour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
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
