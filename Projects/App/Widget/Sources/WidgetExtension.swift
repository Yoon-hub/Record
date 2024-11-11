//
//  WidgetExtension.swift
//  App
//
//  Created by 윤제 on 11/4/24.
//

import WidgetKit
import SwiftUI

import Domain
import Data

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let current = Date()
        
        let entry1 = SimpleEntry(date: current)
        entries.append(entry1)
        
        for i in 0..<1 {
            let todayMonth = Calendar.current.dateComponents([.month, .year, .day, .hour], from: current)
            
            var dateComponents = DateComponents(hour: 0)
            dateComponents.year = todayMonth.year
            dateComponents.month = todayMonth.month
            dateComponents.day = todayMonth.day! + 1
            
            let date = Calendar.current.date(from: dateComponents)
            let entry2 = SimpleEntry(date: date!)
            entries.append(entry2)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WidgetExtensionEntryView: View {
    var entry: Provider.Entry
    var eventsToday: [CalendarEvent] = WidgetEventProvider.default.todayEvents
    var eventsNextDay: [CalendarEvent] = WidgetEventProvider.default.nextDayEvnets
    
    init(entry: Provider.Entry) {
        WidgetEventProvider.default.fetchEvent()
        self.entry = entry
    }
    
    var body: some View {
        VStack {
            ToDayView(date: Date(),eventsToday: eventsToday)
            ToDayView(date: Date().addingTimeInterval(24 * 60 * 60),eventsToday: eventsNextDay)
        }
    }
}

struct WidgetExtension: Widget {
    let kind: String = "tomatoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetExtensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetExtensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("토마토 위젯")
        .description("토마토 위젯입니다.")
    }
}

#Preview(as: .systemSmall) {
    WidgetExtension()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}

