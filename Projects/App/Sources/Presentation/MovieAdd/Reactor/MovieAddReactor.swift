//
//  MovieAddReactor.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import UIKit

import ReactorKit
import Data
import Domain

final class MovieAddReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case addImage(UIImage)
        case didTapSaveButton(String?, String?)
        case didTapImageCell(IndexPath)
    }
    
    enum Mutation {
        case addImage(UIImage)
        case saveSucess
        case errorMessage(String)
        case removeIndex(IndexPath)
    }
    
    struct State {
        var imageItems: [UIImage] = []
        
        @Pulse var showAlert: String?
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    let swiftDataRepository = SwiftDataRepository<Movie>()
}

extension MovieAddReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapImageCell(let index):
            return .just(.removeIndex(index))
        case .addImage(let image):
            return .just(.addImage(image))
        case let .didTapSaveButton(title, content):
            
            guard let title, let content else {
                return .just(.errorMessage("title과 content를 입력해 주세요"))
            }
            
            if title.isEmpty || content.isEmpty {
                return .just(.errorMessage("title과 content를 입력해 주세요"))
            }
            
            if currentState.imageItems.isEmpty {
                return .just(.errorMessage("이미지를 추가해 주세요"))
            }
            
            let movie = Movie(id: "aaa", title: "aaaa", content: "aaaa", image: "aaaa", date: Date())
            try! swiftDataRepository.insertData(data: movie)
            
            return .just(.saveSucess)
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
        case .errorMessage(let error):
            newState.showAlert = error
        case .saveSucess:
            return newState
        case .removeIndex(let index):
            var imageList = state.imageItems
            imageList.remove(at: index.row)
            newState.imageItems = imageList
        }
        
        return newState
    }
}
