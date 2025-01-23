//
//  CalendarEventBuilder.swift
//  Domain
//
//  Created by 윤제 on 1/15/25.
//

import Foundation

import Core
import Design

final public class EventBuilder {
    private var title: String = "제목없음"
    private var date: Date = Date()
    private var endDate: Date = Date()
    private var alarm: String = CalendarEvent.Alarm.none.rawValue
    private var content: String?
    private var tagColor: String = Theme.theme.hexString
    
    enum EventBuilderError: Error {
        case invalidDictionary
    }
    
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
    
    /// 가져온 앱스킴 Evnet로 변경
    public func buildWithDictionary(_ dictionary: [String: String]) -> Result<CalendarEvent, Error> {
        guard let title = dictionary["title"],
              let date = dictionary["startDate"],
              let startDate = date.toDate(),
              let endDate = dictionary["endDate"],
              let endDateType = endDate.toDate(),
              let alarm = dictionary["alarm"],
              let content = dictionary["body"],
              let tagColor = dictionary["tagColor"] else { return .failure(Self.EventBuilderError.invalidDictionary) }
        
        let event = CalendarEvent(
            title: title,
            alarm: alarm,
            date: startDate,
            endDate: endDateType,
            content: content,
            tagColor: "#" + tagColor
        )
        return .success(event)
    }
}
