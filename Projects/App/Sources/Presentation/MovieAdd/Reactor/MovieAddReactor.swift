//
//  MovieAddReactor.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import Foundation

import ReactorKit

final class MovieAddReactor: Reactor {
    
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

extension MovieAddReactor {
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
    }
}
