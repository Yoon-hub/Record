//
//  Event.swift
//  Domain
//
//  Created by 윤제 on 8/23/24.
//

import SwiftData
import UIKit

import Core
import Design

@Model
final public class CalendarEvent: Equatable, EventRepresentable {
    
    public enum Alarm: String, CaseIterable {
        case none = "알림 없음"
        case oneMinute = "1분 전"
        case fiveMinute = "5분 전"
        case tenMinute = "10분 전"
        case thirtyMinute = "30분 전"
        case oneHour = "1시간 전"
        case twoHour = "2시간 전"
        case threeHour = "3시간 전"
        
        // 특정 Date 기준으로 알람 시간 계산
        public func timeBefore(from date: Date) -> Date? {
            switch self {
            case .none:
                return nil // 알림 없음은 시간 계산이 필요 없음
            case .oneMinute:
                return Calendar.current.date(byAdding: .minute, value: -1, to: date)
            case .fiveMinute:
                return Calendar.current.date(byAdding: .minute, value: -5, to: date)
            case .tenMinute:
                return Calendar.current.date(byAdding: .minute, value: -10, to: date)
            case .thirtyMinute:
                return Calendar.current.date(byAdding: .minute, value: -30, to: date)
            case .oneHour:
                return Calendar.current.date(byAdding: .hour, value: -1, to: date)
            case .twoHour:
                return Calendar.current.date(byAdding: .hour, value: -2, to: date)
            case .threeHour:
                return Calendar.current.date(byAdding: .hour, value: -3, to: date)
            }
        }
    }
    
    @Attribute(.unique) public var id: String
    public var title: String
    public var startDate: Date
    public var endDate: Date
    public var alarm: String?
    public var content: String?
    public var tagColor: String // hex String
    
    public var identity: String? {
        id
    }
    
    internal init(
        id: String? = nil,
        title: String,
        alarm: String?,
        date: Date,
        endDate: Date,
        content: String?,
        tagColor: String
    ) {
        self.id = UUID().uuidString
        self.title = title
        self.startDate = date
        self.alarm = alarm
        self.content = content
        self.endDate = endDate
        self.tagColor = tagColor
    }
}
    