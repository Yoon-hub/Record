//
//  PillReactor.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class PillReactor: Reactor {
    
    enum Action {

    }
    
    enum Mutation {
        
    }
    
    struct State {

    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutation
extension PillReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        }
        
        return newState
    }
}
