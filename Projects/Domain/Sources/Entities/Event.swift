//
//  Event.swift
//  Domain
//
//  Created by 윤제 on 8/23/24.
//

import SwiftData
import UIKit

@Model
final public class Event {
    @Attribute(.unique) public var id: String?
    public var title: String
    public var date: Date
    public var alarm: Date?
    public var content: String?
    public var tagColor: String // hex String
    
    internal init(
        id: String? = nil,
        title: String,
        alarm: Date?,
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
    private var title: String = ""
    private var date: Date = Date()
    private var alarm: Date?
    private var content: String?
    private var tagColor: String = ""
    
    public init() { }
    
    public func setTitle(_ title: String) -> EventBuilder {
        self.title = title
        return self
    }
    
    public func setDate(_ date: Date) -> EventBuilder {
        self.date = date
        return self
    }
    
    public func setAlarm(_ alarm: Date) -> EventBuilder {
        self.alarm = alarm
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
    
    public func build() -> Event {
        return Event(
            title: title,
            alarm: alarm, 
            date: date,
            content: content,
            tagColor: tagColor
        )
    }
}
