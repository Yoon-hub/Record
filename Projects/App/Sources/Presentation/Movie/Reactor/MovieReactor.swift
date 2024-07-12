//
//  MovieReactor.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import Foundation

import ReactorKit

final class MovieReactor: Reactor {
    
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

extension MovieReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {

        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
