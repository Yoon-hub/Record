//
//  EventAddReactor.swift
//  App
//
//  Created by 윤제 on 8/20/24.
//

import UIKit

import Core
import Domain
import Design

import ReactorKit

final class EventAddReactor: Reactor {
    
    typealias Alarm = CalendarEvent.Alarm
    
    enum Action {
        case didSeleteStartTime(Date)
        case didSeleceEndTime(Date)
        case didSeleteColor(UIColor)
        case didTapSaveButton(String?, String?)
        case didSeleteAlarm(Alarm)
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
        
        @Pulse var isAlert = false
        @Pulse var saveEvent = false
    }

    let initialState: State
    
    init(seletedDate: Date) {
        self.initialState = State(selectedDate: seletedDate, selectedStartDate: EventAddReactor.makeDefaultTime(date: seletedDate, hour: 8), selectedEndDate: EventAddReactor.makeDefaultTime(date: seletedDate, hour: 9))
    }
    
    @Injected var saveEventUsecase: SaveEventUsecaseProtocol
}
    
extension EventAddReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSeleceEndTime(let date):
            return .just(.setEndTime(date))
        case .didSeleteStartTime(let date):
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
            
            saveEventUsecase.excecute(event: event)
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
extension EventAddReactor {
    static private func makeDefaultTime(date: Date, hour: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = 0

        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func checkDateValidation(startDate: Date, endDate: Date) -> Bool {
        return startDate > endDate
    }
}
