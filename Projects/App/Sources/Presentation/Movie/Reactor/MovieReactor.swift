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
    
    enum TranstionTo: Equatable {
        case addMovie
    }
    
    enum SortedBy {
        case name
        case date
        case `default`
        
        var typeString: String {
            switch self {
            case .name:
                return "name"
            case .date:
                return "date"
            case .default:
                return "default"
            }
        }
    }
    
    // MARK: - Reactor
    enum Action {
        case openNextView(TranstionAction)
        case viewDidLoad
        case didTapSort
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
        case .didTapSort:
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
            let sorted = UserDefaultsWrapper.sorted
            
            if sorted == SortedBy.name.typeString {
                newState.movieItems = sortMoviesByName(movies: movies)
            } else if sorted == SortedBy.date.typeString {
                newState.movieItems = sortMoviesByDate(movies: movies)
            } else {
                newState.movieItems = movies
            }
            
            return newState
        }
    }
}

extension MovieReactor {
    
    func sortMoviesByName(movies: [Movie]) -> [Movie] {
        return movies.sorted { $0.title < $1.title }
    }

    func sortMoviesByDate(movies: [Movie]) -> [Movie] {
        return movies.sorted { $0.date > $1.date }
    }
}
