//
//  MovieDetailReactor.swift
//  App
//
//  Created by 윤제 on 7/31/24.
//

import UIKit

import Core
import Data
import Domain

import ReactorKit

final class MovieDetailReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {

    }
    
    struct State {
        var movie: Movie
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}
