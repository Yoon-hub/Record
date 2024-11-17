//
//  WidgetEventProvider.swift
//  Widget
//
//  Created by 윤제 on 11/8/24.
//

import Foundation

import Domain
import Data

extension WidgetExtensionEntryView {
    
    func getTodayRestDay() -> RestDay? {
        filterRestDayByDate(restDays: self.entry.restDays, date: Date())
    }
    
    func getNextDayRestDay() -> RestDay? {
        filterRestDayByDate(restDays: self.entry.restDays, date: Date().addingTimeInterval(24 * 60 * 60))
    }
    
    func getTodayEvent() -> [CalendarEvent] {
        filterEventsByDate(events: self.entry.events, date: Date())
    }
    
    func getNextDayEvent() -> [CalendarEvent] {
        filterEventsByDate(events: self.entry.events, date: Date().addingTimeInterval(24 * 60 * 60))
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
