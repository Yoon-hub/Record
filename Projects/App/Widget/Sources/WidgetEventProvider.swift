//
//  WidgetEventProvider.swift
//  Widget
//
//  Created by 윤제 on 11/8/24.
//

import Foundation

import Domain
import Data

public class WidgetEventProvider {
    public static let `default` = WidgetEventProvider()
    
    var events: [CalendarEvent] = []
    public var todayEvents: [CalendarEvent] = []
    public var nextDayEvnets: [CalendarEvent] = []
    
    var restDays: [RestDay] = []
    public var todayRestDay: RestDay?
    public var nextDayRestDay: RestDay?
    
    public func fetch() {
        fetchEvent()
        fetchRestDay()
    }
    
    public func fetchEvent() {
        let repository = SwiftDataRepository<CalendarEvent>()
        Task {
            let events = try await repository.fetchData()
            self.events = events
            getTodayEvent()
            getNextDayEvent()
        }
    }
    
    public func fetchRestDay() {
        let repository = SwiftDataRepository<RestDay>()
        Task {
            let restDays = try await repository.fetchData()
            self.restDays = restDays
            getTodayRestDay()
            getNextDayRestDay()
        }
    }
    
    private func getTodayRestDay() {
        self.todayRestDay = filterRestDayByDate(restDays: self.restDays, date: Date())
    }
    
    private func getNextDayRestDay() {
        self.nextDayRestDay = filterRestDayByDate(restDays: self.restDays, date: Date().addingTimeInterval(24 * 60 * 60))
    }
    
    private func getTodayEvent() {
        self.todayEvents = filterEventsByDate(events: self.events, date: Date())
    }
    
    private func getNextDayEvent() {
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
    
    private func filterRestDayByDate(restDays: [RestDay], date: Date) -> RestDay? {
        let calendar = Calendar.current
        
        return restDays.first { restDay in
            let restDayDate = calendar.startOfDay(for: restDay.date)
            let targetDate = calendar.startOfDay(for: date)
            
            return restDayDate == targetDate
        }
    }

}
