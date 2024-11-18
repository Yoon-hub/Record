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
    typealias Entry = WidgetEntry

    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), events: [], restDays: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        Task {
            let entry = await fetchData()
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        Task {
            let entry = await fetchData()
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))) // 1시간마다 갱신
            completion(timeline)
        }
    }

    private func fetchData() async -> WidgetEntry {
        do {
            let eventsRepository = SwiftDataRepository<CalendarEvent>()
            let restDaysRepository = SwiftDataRepository<RestDay>()

            let events = try await eventsRepository.fetchData()
            let restDays = try await restDaysRepository.fetchData()

            return WidgetEntry(date: Date(), events: events, restDays: restDays)
        } catch {
            // 에러가 발생하면 기본 데이터 반환
            return WidgetEntry(date: Date(), events: [], restDays: [])
        }
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let events: [CalendarEvent]
    let restDays: [RestDay]
}

struct WidgetExtensionEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    @State private var date = Date()
    
    var body: some View {
        
        switch widgetFamily {
        case .systemMedium:
            HStack {
                VStack {
                    ToDayView(date: Date(),eventsToday: getTodayEvent(), restDay: getTodayRestDay())
                    ToDayView(date: Date().addingTimeInterval(24 * 60 * 60),eventsToday: getNextDayEvent(), restDay: getNextDayRestDay())
                }
                CalenderView(month: Date(), offset: CGSize(width: 200, height: 30), restDays: entry.restDays)
                    .frame(width: 182)
            }
        default:
            VStack {
                ToDayView(date: Date(),eventsToday: getTodayEvent(), restDay: getTodayRestDay())
                ToDayView(date: Date().addingTimeInterval(24 * 60 * 60),eventsToday: getNextDayEvent(), restDay: getNextDayRestDay())
            }
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

//#Preview(as: .systemSmall) {
//    WidgetExtension()
//} timeline: {
//    SimpleEntry(date: .now)
//    SimpleEntry(date: .now)
//}

