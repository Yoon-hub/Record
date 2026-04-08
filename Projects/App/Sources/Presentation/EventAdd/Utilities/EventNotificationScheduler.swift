//
//  EventNotificationScheduler.swift
//  App
//

import Foundation

import Core
import Domain

enum EventNotificationScheduler {
    
    /// 일정 저장 후 로컬 알림 등록. 기존 `identifier` 요청은 제거 후 재등록.
    static func reschedule(
        event: CalendarEvent,
        alarm: CalendarEvent.Alarm,
        recurrence: EventRecurrenceOption,
        templateStartDate: Date
    ) {
        LocalPushService.shared.removeNotification(identifiers: [event.id])
        guard alarm != .none else { return }
        
        let fire = alarm.timeBefore(from: templateStartDate) ?? templateStartDate
        let cal = Calendar.current
        let hour = cal.component(.hour, from: fire)
        let minute = cal.component(.minute, from: fire)
        let title = event.title
        let body = event.content ?? ""
        
        switch recurrence {
        case .none:
            LocalPushService.shared.addNotification(
                identifier: event.id,
                title: title,
                body: body,
                date: fire
            )
        case .daily:
            LocalPushService.shared.addRepeatingNotification(
                identifier: event.id,
                title: title,
                body: body,
                hour: hour,
                minute: minute
            )
        case .weekly:
            let weekday = cal.component(.weekday, from: templateStartDate)
            LocalPushService.shared.addWeeklyRepeatingNotification(
                identifier: event.id,
                title: title,
                body: body,
                weekday: weekday,
                hour: hour,
                minute: minute
            )
        case .monthly:
            let day = cal.component(.day, from: templateStartDate)
            LocalPushService.shared.addMonthlyRepeatingNotification(
                identifier: event.id,
                title: title,
                body: body,
                day: day,
                hour: hour,
                minute: minute
            )
        }
    }
}
