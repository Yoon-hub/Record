//
//  MovieAddReactor.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import UIKit

import Core
import Data
import Domain

import ReactorKit

final class MovieAddReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case addImage(UIImage)
        case didTapSaveButton(String?, String?, Date)
        case didTapImageCell(IndexPath)
        case didTapRateStar(Int)
    }
    
    enum Mutation {
        case addImage(UIImage)
        case saveSucess
        case errorMessage(String)
        case removeIndex(IndexPath)
        case changeRate(Int)
    }
    
    struct State {
        var imageItems: [UIImage] = []
        var rate = 0
        
        @Pulse var showAlert: String?
        @Pulse var isSaveSucess: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    @Injected var saveMovieUsecase: SaveMovieUsecaseProtocol
}

extension MovieAddReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapImageCell(let index):
            return .just(.removeIndex(index))
        case .addImage(let image):
            return .just(.addImage(image))
        case let .didTapSaveButton(title, content, date):
            
            guard let title, let content else {
                return .just(.errorMessage("title과 content를 입력해 주세요"))
            }
            
            if title.isEmpty || content.isEmpty {
                return .just(.errorMessage("title과 content를 입력해 주세요"))
            }
            
            if currentState.imageItems.isEmpty {
                return .just(.errorMessage("이미지를 추가해 주세요"))
            }
            
            let imageData = currentState.imageItems.map { $0.toData(compressionQuality: 0.5) }
            let movie = MovieBuilder()
                .setTitle(title)
                .setContent(content)
                .setImage(imageData)
                .setDate(date)
                .setRate(currentState.rate)
                .build()
            
            saveMovieUsecase.execute(movie: movie)
            return .just(.saveSucess)
        case .didTapRateStar(let number):
            return .just(.changeRate(number))
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
            newState.isSaveSucess = true
        case .removeIndex(let index):
            var imageList = state.imageItems
            imageList.remove(at: index.row)
            newState.imageItems = imageList
        case .changeRate(let rate):
            newState.rate = rate
        }
        
        return newState
    }
}
