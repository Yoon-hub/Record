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
    
    let repository: any SwiftDataRepositoryProtocol
    
    @State private var events: [CalendarEvent] = []
    
    var body: some View {
        VStack {
            if events.isEmpty {
                Text("\(events.count)")
            } else {
                ForEach(events, id: \.id) { event in
                    Text(event.title)
                }
            }
        }
        .task {
            await loadEvents()
        }
    }
    
    private func loadEvents() async {
        do {
            if let fetchedEvents = try await repository.fetchData() as? [CalendarEvent] {
                await MainActor.run {
                    events = fetchedEvents
                }
            } else {
                print("Data 형식이 맞지 않습니다.")
            }
        } catch {
            print("데이터를 가져오는데 실패했습니다: \(error.localizedDescription)")
        }
    }
}

struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetExtensionEntryView(entry: entry, repository: SwiftDataRepository<CalendarEvent>())
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetExtensionEntryView(entry: entry, repository: SwiftDataRepository<CalendarEvent>())
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    WidgetExtension()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

