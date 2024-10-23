//
//  EventAddReactor.swift
//  App
//
//  Created by 윤제 on 8/20/24.
//

import UIKit

import Core
import Domain
import Design

import ReactorKit

final class EventAddReactor: Reactor {
    
    typealias Alarm = CalendarEvent.Alarm
    
    enum Action {
        case didSeleteStartTime(Date)
        case didSeleceEndTime(Date)
        case didSeleteColor(UIColor)
        case didTapSaveButton(String?, String?)
        case didSeleteAlarm(Alarm)
    }
    
    enum Mutation {
        case setTime(Date)
        case setEndTime(Date)
        case setColor(UIColor)
        case saveEvent
        case setAlarm(Alarm)
        case popAlert(String)
    }
    
    struct State {
        var selectedDate: Date
        var selectedStartDate: Date
        var selectedEndDate: Date
        var selectedColor = UserDefaultsWrapper.color.toUIColor() ?? DesignAsset.record.color
        var selectedAlarm: Alarm = .none
        
        @Pulse var isAlert: String = ""
        @Pulse var saveEvent = false
    }

    let initialState: State
    
    init(seletedDate: Date) {
        self.initialState = State(selectedDate: seletedDate, selectedStartDate: EventAddReactor.makeDefaultTime(date: seletedDate, hour: 8), selectedEndDate: EventAddReactor.makeDefaultTime(date: seletedDate, hour: 9))
    }
    
    @Injected var saveEventUsecase: SaveEventUsecaseProtocol
}
    
extension EventAddReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSeleceEndTime(let date):
            return .just(.setEndTime(date))
        case .didSeleteStartTime(let date):
            if date > currentState.selectedEndDate {
                return .concat([
                    .just(.setTime(date)),
                    .just(.setEndTime(date.addingTimeInterval(3600)))
                    ])
            }
            return .just(.setTime(date))
        case .didSeleteColor(let color):
            return .just(.setColor(color))
        case .didTapSaveButton(let title, let content):
            return Observable.create { [weak self] observer in
                guard let self else {return Disposables.create()}
                Task {
                    // 이벤트 생성
                    let event = EventBuilder()
                        .setAlarm(self.currentState.selectedAlarm)
                        .setDate(self.currentState.selectedStartDate)
                        .setEndDate(self.currentState.selectedEndDate)
                        .setTagColor(self.currentState.selectedColor.hexString)
                        .setTitle(title)
                        .setContent(content ?? "")
                        .build()

                    // 날짜 유효성 검사
                    if self.checkDateValidation(startDate: self.currentState.selectedStartDate, endDate: self.currentState.selectedEndDate) {
                        observer.onNext(.popAlert("시작 날짜는 종료 날짜 이전이어야 합니다."))
                        observer.onCompleted()
                        return
                    }
                    
                    // 권한 요청 비동기 처리
                    if self.currentState.selectedAlarm != .none {
                        let result = await LocalPushService.shared.requestAuthorization()
                        if !result {
                            observer.onNext(.popAlert("알림 사용을 하기 위해서는 권한 허용이 필요합니다."))
                            observer.onCompleted()
                            return
                        } else {
                            LocalPushService.shared.addNotification(identifier: event.id, title: event.title, body: event.content ?? "", date: self.currentState.selectedAlarm.timeBefore(from: event.startDate) ?? event.startDate)
                        }
                    }
                    
                    
                    // 마지막 색상 저장
                    UserDefaultsWrapper.color = self.currentState.selectedColor.hexString
                    // 이벤트 저장
                    self.saveEventUsecase.excecute(event: event)
                    
                    observer.onNext(.saveEvent)
                    observer.onCompleted()
                }
                
                return Disposables.create()
            }
        case .didSeleteAlarm(let alarm):
            return .just(.setAlarm(alarm))
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .popAlert(let message):
            newState.isAlert = message
        case .saveEvent:
            newState.saveEvent = true
        case .setTime(let date):
            newState.selectedStartDate = date
        case .setEndTime(let date):
            newState.selectedEndDate = date
        case .setColor(let color):
            newState.selectedColor = color
        case .setAlarm(let alarm):
            newState.selectedAlarm = alarm
        }
        return newState
    }
}

// MARK: - UserDefione
extension EventAddReactor {
    static private func makeDefaultTime(date: Date, hour: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = 0

        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func checkDateValidation(startDate: Date, endDate: Date) -> Bool {
        return startDate > endDate
    }
}
