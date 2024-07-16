//
//  MovieReactor.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import Foundation

import ReactorKit

final class MovieReactor: Reactor {
    
    // MARK: Transition
    enum TranstionAction {
        case didTapRightBarButtonItem
    }
    
    enum TranstionTo {
        case addMovie
    }
    
    // MARK: - Reactor
    enum Action {
        case openNextView(TranstionAction)
    }
    
    enum Mutation {
        case showNextView(TranstionTo)
    }
    
    struct State {
        @Pulse var openNextView: TranstionTo?
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension MovieReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .openNextView(let transtionAction):
            switch transtionAction {
            case .didTapRightBarButtonItem:
                return Observable.just(.showNextView(.addMovie))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .showNextView(let transitionTo):
            newState.openNextView = transitionTo
            return newState
        }
    }
}
