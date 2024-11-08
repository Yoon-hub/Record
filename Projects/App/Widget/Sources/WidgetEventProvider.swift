//
//  WidgetEventProvider.swift
//  Widget
//
//  Created by 윤제 on 11/8/24.
//

import Foundation

import Domain
import Data

class WidgetEventProvider {
    static let `default` = WidgetEventProvider()
    
    var events: [CalendarEvent] = []
    var todayEvents: [CalendarEvent] = []
    var nextDayEvnets: [CalendarEvent] = []
    
    func fetchEvent() {
        let repository = SwiftDataRepository<CalendarEvent>()
        Task {
            let events = try await repository.fetchData()
            self.events = events
            getTodayEvent()
            getNextDayEvnet()
        }
    }
    
    private func getTodayEvent() {
        self.todayEvents = filterEventsByDate(events: self.events, date: Date())
    }
    
    private func getNextDayEvnet() {
        self.nextDayEvnets = filterEventsByDate(events: self.events, date: Date().addingTimeInterval(24 * 60 * 60))
    }
    
    private func filterEventsByDate(events: [CalendarEvent], date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        
        return events.filter { event in
            let eventStartDate = calendar.startOfDay(for: event.startDate)
            let eventEndDate = calendar.startOfDay(for: event.endDate)
            let targetDate = calendar.startOfDay(for: date)
            
            return eventStartDate <= targetDate && targetDate <= eventEndDate
        }
    }

}
