//
//  MovieAddReactor.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import UIKit

import ReactorKit

final class MovieAddReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case addImage(UIImage)
    }
    
    enum Mutation {
        case addImage(UIImage)
    }
    
    struct State {
        var imageItems: [UIImage] = []
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension MovieAddReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addImage(let image):
            return .just(.addImage(image))
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .addImage(let image):
            var imageList = state.imageItems
            imageList.append(image)
            newState.imageItems = imageList
        }
        
        return newState
    }
}
