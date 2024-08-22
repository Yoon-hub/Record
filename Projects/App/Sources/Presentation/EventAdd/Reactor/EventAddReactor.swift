//
//  EventAddReactor.swift
//  App
//
//  Created by 윤제 on 8/20/24.
//

import Foundation

import ReactorKit

final class EventAddReactor: Reactor {
    
    enum Action {
        case didSeleteTime(Date)
    }
    
    enum Mutation {
        case setTime(Date)
    }
    
    struct State {
        var selectedDate: Date
        var selectedTime: Date
    }

    let initialState: State
    
    init(seletedDate: Date) {
        self.initialState = State(selectedDate: seletedDate, selectedTime: EventAddReactor.makeDefaultTime(date: seletedDate))
    }
}

extension EventAddReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSeleteTime(let date):
            return .just(.setTime(date))
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .setTime(let date):
            newState.selectedTime = date
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
