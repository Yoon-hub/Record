//
//  DiaryReactor.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import Core
import Domain

import ReactorKit

final class DiaryReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewDidLoad
        case saveDiary(content: String)
        case deleteDiary(Diary)
    }
    
    enum Mutation {
        case setDiaries([Diary])
        case addDiary(Diary)
        case removeDiary(Diary)
    }
    
    struct State {
        var diaries: [Diary] = []
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    @Injected var fetchDiaryUsecase: FetchDiaryUsecaseProtocol
    @Injected var saveDiaryUsecase: SaveDiaryUsecaseProtocol
    @Injected var deleteDiaryUsecase: DeleteDiaryUsecaseProtocol
}

extension DiaryReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let diaries = await self.fetchDiaryUsecase.execute()
                    observer.onNext(.setDiaries(diaries))
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            
        case .saveDiary(let content):
            guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return Observable.empty()
            }
            
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let diary = Diary(content: content, date: Date())
                    await self.saveDiaryUsecase.execute(diary: diary)
                    observer.onNext(.addDiary(diary))
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            
        case .deleteDiary(let diary):
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    await self.deleteDiaryUsecase.execute(diary: diary)
                    observer.onNext(.removeDiary(diary))
                    observer.onCompleted()
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
        case .setDiaries(let diaries):
            newState.diaries = diaries
            return newState
            
        case .addDiary(let diary):
            var diaries = newState.diaries
            diaries.insert(diary, at: 0) // 최신순으로 맨 앞에 추가
            newState.diaries = diaries
            return newState
            
        case .removeDiary(let diary):
            newState.diaries = newState.diaries.filter { $0.id != diary.id }
            return newState
        }
    }
}


