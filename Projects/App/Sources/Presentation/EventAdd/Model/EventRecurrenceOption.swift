//
//  EventRecurrenceOption.swift
//  App
//

import Foundation

import Domain

enum EventRecurrenceOption: Equatable, CaseIterable {
    case none
    case daily
    case weekly
    case monthly
    
    var title: String {
        switch self {
        case .none: return "반복 없음"
        case .daily: return "매일"
        case .weekly: return "매주"
        case .monthly: return "매월"
        }
    }
    
    static func from(_ event: CalendarEvent) -> EventRecurrenceOption {
        guard let f = event.recurrenceFrequency, !f.isEmpty else { return .none }
        switch f {
        case "daily": return .daily
        case "weekly": return .weekly
        case "monthly": return .monthly
        default: return .none
        }
    }
    
    /// 빌더·저장용. `weekday`는 매주일 때 `templateStart`의 요일을 씀.
    func storageTuple(templateStart: Date) -> (frequency: String?, weekday: Int?, endDate: Date?) {
        switch self {
        case .none:
            return (nil, nil, nil)
        case .daily:
            return ("daily", nil, nil)
        case .weekly:
            let wd = Calendar.current.component(.weekday, from: templateStart)
            return ("weekly", wd, nil)
        case .monthly:
            return ("monthly", nil, nil)
        }
    }
}
