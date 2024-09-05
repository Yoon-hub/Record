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
final public class CalendarEvent: Equatable {
    
    public enum Alarm: String, CaseIterable {
        case none = "알림 없음"
        case oneMinute = "1분 전"
        case fiveMinute = "5분 전"
        case tenMinute = "10분 전"
        case thirtyMinute = "30분 전"
        case oneHour = "1시간 전"
        
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
            }
        }
    }
    
    @Attribute(.unique) public var id: String?
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

final public class EventBuilder {
    private var title: String = "제목없음"
    private var date: Date = Date()
    private var endDate: Date = Date()
    private var alarm: String = CalendarEvent.Alarm.none.rawValue
    private var content: String?
    private var tagColor: String = DesignAsset.record.color.hexString
    
    public init() { }
    
    public func setTitle(_ title: String?) -> EventBuilder {
        self.title = title ?? "제목없음"
        
        if title == "" {
            self.title = "no title"
        }
        return self
    }
    
    public func setDate(_ date: Date) -> EventBuilder {
        self.date = date
        return self
    }
    
    public func setEndDate(_ endDate: Date) -> EventBuilder {
        self.endDate = endDate
        return self
    }
    
    public func setAlarm(_ alarm: CalendarEvent.Alarm) -> EventBuilder {
        self.alarm = alarm.rawValue
        return self
    }
    
    public func setContent(_ content: String) -> EventBuilder {
        self.content = content
        return self
    }
    
    public func setTagColor(_ tagColor: String) -> EventBuilder {
        self.tagColor = tagColor
        return self
    }
    
    public func build() -> CalendarEvent {
        return CalendarEvent(
            title: title,
            alarm: alarm,
            date: date,
            endDate: endDate,
            content: content,
            tagColor: tagColor
        )
    }
}
