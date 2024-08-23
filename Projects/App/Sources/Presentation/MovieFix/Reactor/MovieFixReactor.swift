//
//  MovieFixReactor.swift
//  App
//
//  Created by 윤제 on 8/9/24.
//

import UIKit

import Core
import Data
import Domain

import ReactorKit

final class MovieFixReactor: Reactor {
    
    enum Action {
        case addImage(UIImage)
        case didTapSaveButton(String?, String?, Date)
        case didTapImageCell(IndexPath)
        case didTapRateStar(Int)
        case viewDidLoad
    }
    
    enum Mutation {
        case addImage(UIImage)
        case saveSucess
        case errorMessage(String)
        case removeIndex(IndexPath)
        case changeRate(Int)
        case settingMovie
    }
    struct State {
        var movie: Movie
        
        var imageItems: [UIImage] = []
        var rate = 0
        
        @Pulse var showAlert: String?
        @Pulse var isSaveSucess: Bool = false
        @Pulse var isSettingMovie: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension MovieFixReactor {
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
            
            let imageData = currentState.imageItems.map { $0.toData() }
            let movie = MovieBuilder()
                .setTitle(title)
                .setContent(content)
                .setImage(imageData)
                .setDate(date)
                .setRate(currentState.rate)
                .build()
       
            fixMovie(movie: movie)
            
            return .just(.saveSucess)
        case .didTapRateStar(let number):
            return .just(.changeRate(number))
        case .viewDidLoad:
            return .just(.settingMovie)
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
        case .settingMovie:
            var imageList: [UIImage] = []
            newState.movie.image.forEach { imageList.append($0.toImage())}
            newState.imageItems = imageList
            newState.rate = newState.movie.rate
            newState.isSettingMovie = true
        }
        
        return newState
    }
}

extension MovieFixReactor {
    private func fixMovie(movie: Movie) {
        currentState.movie.title = movie.title
        currentState.movie.content = movie.content
        currentState.movie.date = movie.date
        currentState.movie.image = movie.image
        currentState.movie.rate = movie.rate
    }
}
