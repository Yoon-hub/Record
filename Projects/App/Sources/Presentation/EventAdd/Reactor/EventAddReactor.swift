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
        case didSeleteTime(Date)
        case didSeleteColor(UIColor)
        case didTapSaveButton(String?, String?)
        case didSeleteAlarm(Alarm)
    }
    
    enum Mutation {
        case setTime(Date)
        case setColor(UIColor)
        case saveEvent
        case setAlarm(Alarm)
    }
    
    struct State {
        var selectedDate: Date
        var selectedTime: Date
        var selectedColor = DesignAsset.record.color
        var selectedAlarm: Alarm = .none
        
        @Pulse var saveEvent = false
    }

    let initialState: State
    
    init(seletedDate: Date) {
        self.initialState = State(selectedDate: seletedDate, selectedTime: EventAddReactor.makeDefaultTime(date: seletedDate))
    }
    
    @Injected var saveEventUsecase: SaveEventUsecaseProtocol
}
    
extension EventAddReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSeleteTime(let date):
            return .just(.setTime(date))
        case .didSeleteColor(let color):
            return .just(.setColor(color))
        case .didTapSaveButton(let title, let content):
            
            let event = EventBuilder()
                .setAlarm(currentState.selectedAlarm)
                .setDate(currentState.selectedTime)
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
        case .saveEvent:
            newState.saveEvent = true
        case .setTime(let date):
            newState.selectedTime = date
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
    static private func makeDefaultTime(date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 8
        components.minute = 0

        return Calendar.current.date(from: components) ?? Date()
    }
}
