//
//  CalendarEvent+Recurrence.swift
//  Domain
//

import Foundation

public extension CalendarEvent {
    
    var isRecurring: Bool {
        guard let f = recurrenceFrequency, !f.isEmpty else { return false }
        return true
    }
    
    /// `targetDate`가 속한 날에 이 일정이 표시되어야 하면 true (반복·단일 모두)
    func occurs(on targetDate: Date) -> Bool {
        let cal = Calendar.current
        let target = cal.startOfDay(for: targetDate)
        
        guard isRecurring else {
            let eventStart = cal.startOfDay(for: startDate)
            let eventEnd = cal.startOfDay(for: endDate)
            return eventStart <= target && target <= eventEnd
        }
        
        guard let freq = recurrenceFrequency else { return false }
        
        let seriesStart = cal.startOfDay(for: startDate)
        guard target >= seriesStart else { return false }
        
        if let end = recurrenceEndDate {
            guard target <= cal.startOfDay(for: end) else { return false }
        }
        
        switch freq {
        case "weekly":
            guard let wd = recurrenceWeekday else { return false }
            return cal.component(.weekday, from: target) == wd
        case "daily":
            return true
        case "monthly":
            return cal.component(.day, from: target) == cal.component(.day, from: startDate)
        default:
            return false
        }
    }
    
    /// 캘린더의 특정 날 칸에 그릴 때 시작 시각 (반복이면 해당 날짜 + 템플릿 시·분)
    func displayStartDate(forCalendarDay day: Date) -> Date {
        guard isRecurring else { return startDate }
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day], from: cal.startOfDay(for: day))
        let time = cal.dateComponents([.hour, .minute, .second], from: startDate)
        comps.hour = time.hour
        comps.minute = time.minute
        comps.second = time.second
        return cal.date(from: comps) ?? startDate
    }
    
    /// 캘린더의 특정 날 칸에 그릴 때 종료 시각
    func displayEndDate(forCalendarDay day: Date) -> Date {
        guard isRecurring else { return endDate }
        let duration = endDate.timeIntervalSince(startDate)
        return displayStartDate(forCalendarDay: day).addingTimeInterval(duration)
    }
}
