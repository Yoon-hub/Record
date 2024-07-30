//
//  MovieReactor.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import Foundation

import Core
import Domain

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
        case viewDidLoad
    }
    
    enum Mutation {
        case showNextView(TranstionTo)
        case addMovie([Movie])
    }
    
    struct State {
        @Pulse var openNextView: TranstionTo?
        var movieItems: [Movie] = []
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    @Injected var fetchMovieUsecase: FetchMovieUsecaseProtocol
}

extension MovieReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .openNextView(let transtionAction):
            switch transtionAction {
            case .didTapRightBarButtonItem:
                return Observable.just(.showNextView(.addMovie))
            }
        case .viewDidLoad:
            return Observable.create {
                [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let movies = await self.fetchMovieUsecase.execute()
                    observer.onNext(.addMovie(movies))
                }
                return Disposables.create()
            }
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .showNextView(let transitionTo):
            newState.openNextView = transitionTo
            return newState
        case .addMovie(let movies):
            newState.movieItems.append(contentsOf: movies)
            print(newState.movieItems)
            return newState
        }
    }
}
