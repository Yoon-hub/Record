//
//  EventSearchReactor.swift
//  App
//
//  Created for event search from Settings.
//

import Foundation

import Core
import Domain

import ReactorKit
import RxSwift

struct EventDaySection {
    /// 해당 섹션에 묶인 날짜(자정 기준)
    let day: Date
    let events: [CalendarEvent]
}

final class EventSearchReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case searchTextChanged(String)
        case reloadEvents
    }
    
    enum Mutation {
        case setAllEvents([CalendarEvent])
        case setSearchText(String)
    }
    
    struct State {
        var allEvents: [CalendarEvent] = []
        var searchText: String = ""
        /// 검색어가 있을 때만 채워짐 — 날짜 최신순, 같은 날 일정은 시작 시각 최신순
        var eventDaySections: [EventDaySection] = []
    }
    
    let initialState: State
    
    @Injected var fetchEventUsecase: FetchEventUsecaseProtocol
    
    init() {
        self.initialState = State()
    }
}

extension EventSearchReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad, .reloadEvents:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let events = await self.fetchEventUsecase.execute()
                    observer.onNext(.setAllEvents(events))
                }
                return Disposables.create()
            }
        case .searchTextChanged(let text):
            return Observable.just(Mutation.setSearchText(text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setAllEvents(let events):
            newState.allEvents = events
            newState.eventDaySections = Self.buildDaySections(
                from: Self.filteredEvents(from: events, query: newState.searchText)
            )
        case .setSearchText(let text):
            newState.searchText = text
            newState.eventDaySections = Self.buildDaySections(
                from: Self.filteredEvents(from: newState.allEvents, query: text)
            )
        }
        return newState
    }
    
    private static func filteredEvents(from events: [CalendarEvent], query: String) -> [CalendarEvent] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        return events.filter { event in
            event.title.localizedCaseInsensitiveContains(trimmed)
                || (event.content?.localizedCaseInsensitiveContains(trimmed) ?? false)
        }
    }
    
    private static func buildDaySections(from events: [CalendarEvent]) -> [EventDaySection] {
        guard !events.isEmpty else { return [] }
        let cal = Calendar.current
        let horizonEnd = cal.date(byAdding: .year, value: 2, to: Date()) ?? Date()
        
        var dayToEvents: [Date: [CalendarEvent]] = [:]
        
        for event in events {
            if !event.isRecurring {
                let d = cal.startOfDay(for: event.startDate)
                dayToEvents[d, default: []].append(event)
                continue
            }
            
            let upperBound: Date
            if let end = event.recurrenceEndDate {
                upperBound = min(horizonEnd, cal.startOfDay(for: end))
            } else {
                upperBound = horizonEnd
            }
            
            var d = cal.startOfDay(for: event.startDate)
            while d <= upperBound {
                if event.occurs(on: d) {
                    let key = cal.startOfDay(for: d)
                    var list = dayToEvents[key] ?? []
                    if !list.contains(where: { $0.id == event.id }) {
                        list.append(event)
                        dayToEvents[key] = list
                    }
                }
                guard let next = cal.date(byAdding: .day, value: 1, to: d) else { break }
                d = next
            }
        }
        
        let sortedDays = dayToEvents.keys.sorted(by: >)
        return sortedDays.map { day in
            let dayEvents = dayToEvents[day]!.sorted {
                $0.displayStartDate(forCalendarDay: day) > $1.displayStartDate(forCalendarDay: day)
            }
            return EventDaySection(day: day, events: dayEvents)
        }
    }
}
