//
//  KoreanHolidayEventKitService.swift
//  App
//
//  Created by Cursor on 4/2/26.
//

import EventKit
import Foundation

/// iOS 캘린더에 구독된 **한국 공휴일** 캘린더에서만 이벤트를 읽습니다.
/// (시스템에 공휴일 캘린더가 없거나 권한이 없으면 빈 배열 또는 오류)
public struct KoreanHolidayCalendarEvent: Sendable {
    public let title: String
    public let startDate: Date
    public let calendarTitle: String
}

public enum KoreanHolidayEventKitServiceError: Error {
    case calendarAccessDenied
    case noMatchingHolidayCalendars
}

public final class KoreanHolidayEventKitService {
    
    private let eventStore = EKEventStore()
    
    public init() {}
    
    /// 전년·올해·내년(각 연도 1/1 ~ 12/31, Asia/Seoul 기준) 구간의 이벤트를 가져옵니다.
    public func fetchKoreanHolidayEvents() async throws -> [KoreanHolidayCalendarEvent] {
        guard try await ensureFullCalendarAccess() else {
            throw KoreanHolidayEventKitServiceError.calendarAccessDenied
        }
        
        let holidayCalendars = Self.koreanHolidayCalendars(from: eventStore)
        guard !holidayCalendars.isEmpty else {
            throw KoreanHolidayEventKitServiceError.noMatchingHolidayCalendars
        }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        calendar.locale = Locale(identifier: "ko_KR")
        
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        
        guard let rangeStart = calendar.date(from: DateComponents(year: currentYear - 1, month: 1, day: 1)),
              let endExclusive = calendar.date(from: DateComponents(year: currentYear + 2, month: 1, day: 1))
        else {
            return []
        }
        
        let predicate = eventStore.predicateForEvents(
            withStart: rangeStart,
            end: endExclusive,
            calendars: holidayCalendars
        )
        let rawEvents = eventStore.events(matching: predicate)
        
        var seen = Set<String>()
        var result: [KoreanHolidayCalendarEvent] = []
        result.reserveCapacity(rawEvents.count)
        
        for event in rawEvents {
            guard event.isAllDay else { continue }
            let dayStart = calendar.startOfDay(for: event.startDate)
            let key = "\(dayStart.timeIntervalSince1970)|\(event.title)"
            guard seen.insert(key).inserted else { continue }
            
            result.append(
                KoreanHolidayCalendarEvent(
                    title: event.title,
                    startDate: dayStart,
                    calendarTitle: event.calendar?.title ?? ""
                )
            )
        }
        
        result.sort { $0.startDate < $1.startDate }
        return result
    }
    
    // MARK: - Access
    
    private func ensureFullCalendarAccess() async throws -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .fullAccess, .authorized:
            return true
        case .writeOnly, .denied, .restricted:
            return false
        case .notDetermined:
            return try await eventStore.requestFullAccessToEvents()
        @unknown default:
            return try await eventStore.requestFullAccessToEvents()
        }
    }
    
    // MARK: - Calendar matching
    
    /// 캘린더 제목으로 한국 공휴일 소스를 추정합니다. (기기/언어/구독에 따라 이름이 다를 수 있음)
    private static func koreanHolidayCalendars(from store: EKEventStore) -> [EKCalendar] {
        let eventCalendars = store.calendars(for: .event)
        return eventCalendars.filter { isLikelyKoreanHolidayCalendar($0) }
    }
    
    private static func isLikelyKoreanHolidayCalendar(_ calendar: EKCalendar) -> Bool {
        let title = calendar.title
        let lower = title.lowercased()
        
        let excludePatterns = ["united states", "미국", "u.s.", "japan", "일본", "china", "중국", "taiwan", "대만", "uk ", "영국"]
        if excludePatterns.contains(where: { lower.contains($0) }) {
            return false
        }
        
        let includePatterns = [
            "한국의 공휴일",
            "대한민국의 공휴일",
            "대한민국",
            "한국",
            "korea",
            "south korea",
            "holidays in korea",
            "korean holiday",
            "공휴일"
        ]
        
        return includePatterns.contains { title.localizedCaseInsensitiveContains($0) }
    }
}
