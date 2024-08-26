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
final public class CalendarEvent {
    
    public enum Alarm: String, CaseIterable {
        case none = "알림 없음"
        case oneMinute = "1분 전"
        case fiveMinute = "5분 전"
        case tenMinute = "10분 전"
        case thirtyMinute = "30분 전"
        case oneHour = "1시간 전"
    }
    
    @Attribute(.unique) public var id: String?
    public var title: String
    public var date: Date
    public var alarm: String?
    public var content: String?
    public var tagColor: String // hex String
    
    internal init(
        id: String? = nil,
        title: String,
        alarm: String?,
        date: Date,
        content: String?,
        tagColor: String
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.alarm = alarm
        self.content = content
        self.tagColor = tagColor
    }
}

final public class EventBuilder {
    private var title: String = "제목없음"
    private var date: Date = Date()
    private var alarm: String = CalendarEvent.Alarm.none.rawValue
    private var content: String?
    private var tagColor: String = DesignAsset.record.color.hexString
    
    public init() { }
    
    public func setTitle(_ title: String?) -> EventBuilder {
        guard let title else {return self}
        self.title = title
        return self
    }
    
    public func setDate(_ date: Date) -> EventBuilder {
        self.date = date
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
            content: content,
            tagColor: tagColor
        )
    }
}
