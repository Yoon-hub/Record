//
//  CalendarReactor.swift
//  App
//
//  Created by 윤제 on 8/12/24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class CalendarReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case didSelectDate(Date)
    }
    
    enum Mutation {
        case setRestDate([RestDay])
        case setSelectDate(Date)
    }
    
    struct State {
        var restDays: [RestDay] = []
        var selectedEvents: [String] = []
        var selectedDate: Date = Date()
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    @Injected var fetchRestDayFromDBUsecase: FetchRestDayFromDBUsecaserotocol
}

extension CalendarReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let restDays = await self.fetchRestDayFromDBUsecase.execute()
                    observer.onNext(.setRestDate(restDays))
                }
                return Disposables.create()
            }
        case .didSelectDate(let date):
            return .just(.setSelectDate(date))
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .setRestDate(let restDays):
            newState.restDays = restDays
            return newState
        case .setSelectDate(let date):
            newState.selectedDate = date
            return newState
        }
    }
}
