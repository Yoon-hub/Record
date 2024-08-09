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
        case didTapDeleteButton
        case didTapHeartButton
        case didTapResetHeartButton
    }
    
    enum Mutation {
        case deleteMovie
        case heartIncrease
        case heartReset
    }
    
    struct State {
        var movie: Movie
        
        
        @Pulse var showAlert: String?
    }
    
    @Injected var deleteMovieUsecase: DeleteMovieUsecaseProtocol
    @Navigator var navigator: MainNaviagatorProtocol
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension MovieDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDeleteButton:
            deleteMovieUsecase.execute(movie: currentState.movie)
            return .just(.deleteMovie)
        case .didTapHeartButton:
            return .just(.heartIncrease)
        case .didTapResetHeartButton:
            return .just(.heartReset)
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .deleteMovie:
            newState.showAlert = "삭제되었습니다."
        case .heartIncrease:
            newState.movie.heart += 1
        case .heartReset:
            newState.movie.heart = 0
        }
        return newState
    }
}
