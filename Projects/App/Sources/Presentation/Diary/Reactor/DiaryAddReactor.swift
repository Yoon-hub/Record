//
//  DiaryAddReactor.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import Core
import Domain

import ReactorKit

final class DiaryAddReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case saveDiary(content: String)
    }
    
    enum Mutation {
        case showErrorAlert(String)
        case saveSuccess
    }
    
    struct State {
        var editingDiary: Diary?
        @Pulse var errorMessage: String?
        @Pulse var isSaveSuccess: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    @Injected var fetchDiaryUsecase: FetchDiaryUsecaseProtocol
    @Injected var saveDiaryUsecase: SaveDiaryUsecaseProtocol
    @Injected var deleteDiaryUsecase: DeleteDiaryUsecaseProtocol
}

extension DiaryAddReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .saveDiary(let content):
            let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !trimmedContent.isEmpty else {
                // 내용이 비어있으면 성공으로 처리 (그냥 나가기)
                return .just(.saveSuccess)
            }
            
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                
                Task {
                    // 수정 모드인 경우
                    if let editingDiary = self.currentState.editingDiary {
                        // 기존 일기 삭제
                        await self.deleteDiaryUsecase.execute(diary: editingDiary)
                        
                        // 새 일기 저장 (기존 날짜 유지)
                        let updatedDiary = Diary(id: editingDiary.id, content: trimmedContent, date: editingDiary.date)
                        await self.saveDiaryUsecase.execute(diary: updatedDiary)
                        
                        // 캘린더 리로드 알림
                        NotificationCenterService.reloadCalendar.post()
                        
                        observer.onNext(.saveSuccess)
                        observer.onCompleted()
                        return
                    }
                    
                    // 추가 모드인 경우 - 중복 체크
                    let today = Date()
                    let calendar = Calendar.current
                    let todayStart = calendar.startOfDay(for: today)
                    let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)!
                    
                    let allDiaries = await self.fetchDiaryUsecase.execute()
                    let todayDiaries = allDiaries.filter { diary in
                        let diaryDate = calendar.startOfDay(for: diary.date)
                        return diaryDate >= todayStart && diaryDate < todayEnd
                    }
                    
                    if !todayDiaries.isEmpty {
                        // 오늘 날짜에 이미 일기가 있으면 에러 표시
                        observer.onNext(.showErrorAlert("이미 해당 날짜에 작성된 일기가 있습니다."))
                        observer.onCompleted()
                        return
                    }
                    
                    // 일기 저장
                    let diary = Diary(content: trimmedContent, date: today)
                    await self.saveDiaryUsecase.execute(diary: diary)
                    
                    // 캘린더 리로드 알림
                    NotificationCenterService.reloadCalendar.post()
                    
                    observer.onNext(.saveSuccess)
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
        case .showErrorAlert(let message):
            newState.errorMessage = message
            return newState
            
        case .saveSuccess:
            newState.isSaveSuccess = true
            return newState
        }
    }
}


