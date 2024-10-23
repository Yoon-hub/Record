//
//  EventFixReactor.swift
//  App
//
//  Created by 윤제 on 9/3/24.
//

import UIKit

import Core
import Domain
import Design

import ReactorKit

final class EventFixReactor: Reactor {
    
    typealias Alarm = CalendarEvent.Alarm
    
    enum Action {
        case didSeleteStartTime(Date)
        case didSeleceEndTime(Date)
        case didSeleteColor(UIColor)
        case didTapSaveButton(String?, String?)
        case didSeleteAlarm(Alarm)
        case viewDidLoad
    }
    
    enum Mutation {
        case setTime(Date)
        case setEndTime(Date)
        case setColor(UIColor)
        case saveEvent
        case setAlarm(Alarm)
        case popAlert
    }
    
    struct State {
        var selectedDate: Date
        var selectedStartDate: Date
        var selectedEndDate: Date
        var selectedColor = DesignAsset.record.color
        var selectedAlarm: Alarm = .none
        
        var currentCalendarEvent: CalendarEvent
        
        @Pulse var isAlert = false
        @Pulse var saveEvent = false
    }

    let initialState: State
    
    init(seletedDate: Date, calendarEvent: CalendarEvent) {
        self.initialState = State(selectedDate: seletedDate, selectedStartDate: EventFixReactor.makeDefaultTime(date: seletedDate, hour: 8), selectedEndDate: EventFixReactor.makeDefaultTime(date: seletedDate, hour: 9), currentCalendarEvent: calendarEvent)
    }
    
    @Injected var saveEventUsecase: SaveEventUsecaseProtocol
}
    
extension EventFixReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let setEndTime = Observable.just(Mutation.setEndTime(currentState.currentCalendarEvent.endDate))
            let setStartTime = Observable.just(Mutation.setTime(currentState.currentCalendarEvent.startDate))
            let setColor = Observable.just(Mutation.setColor(currentState.currentCalendarEvent.tagColor.toUIColor() ?? DesignAsset.record.color))
            
            let alarm = Alarm(rawValue: currentState.currentCalendarEvent.alarm ?? "알림 없음") ?? .none
            let setAlarm = Observable.just(Mutation.setAlarm(alarm))
            
            return Observable.concat([setEndTime, setStartTime, setColor, setAlarm])
        case .didSeleceEndTime(let date):
            return .just(.setEndTime(date))
        case .didSeleteStartTime(let date):
            if date < currentState.selectedEndDate {
                return .concat([
                    .just(.setTime(date)),
                    .just(.setEndTime(date.addingTimeInterval(3600)))
                    ])
            }
            return .just(.setTime(date))
        case .didSeleteColor(let color):
            return .just(.setColor(color))
        case .didTapSaveButton(let title, let content):
            
            if checkDateValidation(startDate: currentState.selectedStartDate, endDate: currentState.selectedEndDate) {
                return .just(.popAlert)
            }
            
            let event = EventBuilder()
                .setAlarm(currentState.selectedAlarm)
                .setDate(currentState.selectedStartDate)
                .setEndDate(currentState.selectedEndDate)
                .setTagColor(currentState.selectedColor.hexString)
                .setTitle(title)
                .setContent(content ?? "")
                .build()
            
            fixEvent(event: event)
            
            return .just(.saveEvent)
        case .didSeleteAlarm(let alarm):
            return .just(.setAlarm(alarm))
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .popAlert:
            newState.isAlert = true
        case .saveEvent:
            newState.saveEvent = true
        case .setTime(let date):
            newState.selectedStartDate = date
        case .setEndTime(let date):
            newState.selectedEndDate = date
        case .setColor(let color):
            newState.selectedColor = color
        case .setAlarm(let alarm):
            newState.selectedAlarm = alarm
        }
        return newState
    }
}

// MARK: - UserDefione
extension EventFixReactor {
    static private func makeDefaultTime(date: Date, hour: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = 0

        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func checkDateValidation(startDate: Date, endDate: Date) -> Bool {
        return startDate > endDate
    }
    
    private func fixEvent(event: CalendarEvent) {
        currentState.currentCalendarEvent.tagColor = event.tagColor
        currentState.currentCalendarEvent.title = event.title
        currentState.currentCalendarEvent.startDate = event.startDate
        currentState.currentCalendarEvent.endDate = event.endDate
        currentState.currentCalendarEvent.content = event.content
        currentState.currentCalendarEvent.alarm = event.alarm
        
        LocalPushService.shared.removeNotification(identifiers: [event.id])
        
        if event.alarm != .none {
            LocalPushService.shared.addNotification(identifier: event.id, title: event.title, body: event.content ?? "", date: Alarm(rawValue: event.alarm ?? Alarm.none.rawValue)?.timeBefore(from: event.startDate) ?? Date())
        }
    }
}
