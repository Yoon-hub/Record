//
//  CalendarReactor.swift
//  App
//
//  Created by 윤제 on 8/12/24.
//

import Foundation

import Core

import ReactorKit

final class CalendarReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension CalendarReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        
    }
}
