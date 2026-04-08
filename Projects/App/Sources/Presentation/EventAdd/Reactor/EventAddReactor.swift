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
        case didTapAlldayButton
        case didSelectRecurrence(EventRecurrenceOption)
    }
    
    enum Mutation {
        case setTime(Date)
        case setEndTime(Date)
        case setColor(UIColor)
        case saveEvent
        case setAlarm(Alarm)
        case setRecurrence(EventRecurrenceOption)
        case popAlert(String)
    }
    
    struct State {
        var selectedDate: Date
        var selectedStartDate: Date
        var selectedEndDate: Date
        var selectedColor = UserDefaultsWrapper.color.toUIColor() ?? Theme.theme
        var selectedAlarm: Alarm = .none
        var selectedRecurrence: EventRecurrenceOption = .none
        
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
                    if self.checkDateValidation(startDate: self.currentState.selectedStartDate, endDate: self.currentState.selectedEndDate) {
                        observer.onNext(.popAlert("시작 날짜는 종료 날짜 이전이어야 합니다."))
                        observer.onCompleted()
                        return
                    }
                    
                    if self.currentState.selectedRecurrence != .none,
                       !Calendar.current.isDate(self.currentState.selectedStartDate, inSameDayAs: self.currentState.selectedEndDate) {
                        observer.onNext(.popAlert("반복 일정은 같은 날 안에서 끝나는 일정만 설정할 수 있어요."))
                        observer.onCompleted()
                        return
                    }
                    
                    let tuple = self.currentState.selectedRecurrence.storageTuple(templateStart: self.currentState.selectedStartDate)
                    let event = EventBuilder()
                        .setAlarm(self.currentState.selectedAlarm)
                        .setDate(self.currentState.selectedStartDate)
                        .setEndDate(self.currentState.selectedEndDate)
                        .setTagColor(self.currentState.selectedColor.hexString)
                        .setTitle(title)
                        .setContent(content ?? "")
                        .setRecurrence(frequency: tuple.frequency, weekday: tuple.weekday, endDate: tuple.endDate)
                        .build()
                    
                    if self.currentState.selectedAlarm != .none {
                        let result = await LocalPushService.shared.requestAuthorization()
                        if !result {
                            observer.onNext(.popAlert("알림 사용을 하기 위해서는 권한 허용이 필요합니다."))
                            observer.onCompleted()
                            return
                        }
                    }
                    
                    UserDefaultsWrapper.color = self.currentState.selectedColor.hexString
                    await self.saveEventUsecase.excecute(event: event)
                    
                    EventNotificationScheduler.reschedule(
                        event: event,
                        alarm: self.currentState.selectedAlarm,
                        recurrence: self.currentState.selectedRecurrence,
                        templateStartDate: self.currentState.selectedStartDate
                    )
                    
                    observer.onNext(.saveEvent)
                    observer.onCompleted()
                }
                
                return Disposables.create()
            }
        case .didSeleteAlarm(let alarm):
            return .just(.setAlarm(alarm))
        case .didSelectRecurrence(let option):
            return .just(.setRecurrence(option))
        case .didTapAlldayButton:
            return .concat([
                .just(.setTime(EventAddReactor.makeDefaultTime(date: currentState.selectedDate, hour: 0))),
                .just(.setEndTime(EventAddReactor.makeDefaultTime(date: currentState.selectedDate, hour: 23, minute: 59))
                )
            ])
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
        case .setRecurrence(let option):
            newState.selectedRecurrence = option
        }
        return newState
    }
}

// MARK: - UserDefione
extension EventAddReactor {
    static public func makeDefaultTime(date: Date, hour: Int, minute: Int = 0) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute

        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func checkDateValidation(startDate: Date, endDate: Date) -> Bool {
        return startDate > endDate
    }
}
