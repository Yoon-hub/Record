//
//  MetamonReactor.swift
//  App
//
//  Created by 윤제 on 9/29/25.
//

import Foundation

import Core

import ReactorKit

final class MetamonReactor: Reactor {
    // MARK: - Reactor
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

extension MetamonReactor {
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
