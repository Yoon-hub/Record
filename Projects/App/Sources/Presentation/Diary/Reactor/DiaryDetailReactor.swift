//
//  DiaryDetailReactor.swift
//  App
//
//  Created by 윤제 on 1/13/25.
//

import Foundation

import Core
import Domain

import ReactorKit

final class DiaryDetailReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setDiary(Diary)
    }
    
    struct State {
        var diary: Diary?
    }
    
    let initialState: State
    private let diary: Diary
    
    init(initialState: State, diary: Diary) {
        self.initialState = initialState
        self.diary = diary
    }
    
    @Injected var fetchDiaryUsecase: FetchDiaryUsecaseProtocol
}

extension DiaryDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setDiary(diary))
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .setDiary(let diary):
            newState.diary = diary
            return newState
        }
    }
}

