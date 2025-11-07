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
        case checkAndNavigateToAdd
    }
    
    enum Mutation {
        case setDiaries([Diary])
        case addDiary(Diary)
        case removeDiary(Diary)
        case showDuplicateAlert
        case navigateToAdd
        case navigateToEdit(Diary)
        case resetNavigateToAdd
        case resetAlert
    }
    
    struct State {  
        var diaries: [Diary] = [] 
        @Pulse var shouldShowAlert: String?
        @Pulse var shouldNavigateToAdd: Bool?
        @Pulse var shouldNavigateToEdit: Diary?
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
                    
                    // 캘린더 리로드 알림
                    NotificationCenterService.reloadCalendar.post()
                    
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
                    
                    // 캘린더 리로드 알림
                    NotificationCenterService.reloadCalendar.post()
                    
                    observer.onNext(.removeDiary(diary))
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            
        case .checkAndNavigateToAdd:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let today = Date()
                    let calendar = Calendar.current
                    let todayStart = calendar.startOfDay(for: today)
                    let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)!
                    
                    let allDiaries = await self.fetchDiaryUsecase.execute()
                    let todayDiaries = allDiaries.filter { diary in
                        let diaryDate = calendar.startOfDay(for: diary.date)
                        return diaryDate >= todayStart && diaryDate < todayEnd
                    }
                    
                    if let todayDiary = todayDiaries.first {
                        // 오늘 날짜에 이미 일기가 있으면 수정 모드로 열기
                        observer.onNext(.navigateToEdit(todayDiary))
                        observer.onNext(.resetNavigateToAdd)
                    } else {
                        // 일기가 없으면 추가 화면으로 이동
                        observer.onNext(.navigateToAdd)
                        // 다음 액션을 위해 리셋
                        observer.onNext(.resetNavigateToAdd)
                    }
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
            diaries.append(diary) // 맨 뒤에 추가 (최신 일기)
            // 날짜순으로 재정렬
            diaries.sort { $0.date < $1.date }
            newState.diaries = diaries
            return newState
            
        case .removeDiary(let diary):
            newState.diaries = newState.diaries.filter { $0.id != diary.id }
            return newState
            
        case .showDuplicateAlert:
            newState.shouldShowAlert = "이미 해당 날짜에 작성된 일기가 있습니다."
            return newState
            
        case .navigateToAdd:
            newState.shouldNavigateToAdd = true
            return newState
            
        case .navigateToEdit(let diary):
            newState.shouldNavigateToEdit = diary
            return newState
            
        case .resetNavigateToAdd:
            newState.shouldNavigateToAdd = nil
            newState.shouldNavigateToEdit = nil
            return newState
            
        case .resetAlert:
            newState.shouldShowAlert = nil
            return newState
        }
    }
}


