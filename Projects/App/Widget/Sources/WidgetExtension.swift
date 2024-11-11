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
        SimpleEntry(date: Date(), emoji: "😀")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
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
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

