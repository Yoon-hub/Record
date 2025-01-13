//
//  EventFixReactor.swift
//  App
//
//  Created by 윤제 on 9/3/24.
//

import UIKit

import Core
import Domain
import Design

import ReactorKit

final class EventFixReactor: Reactor {
    
    typealias Alarm = CalendarEvent.Alarm
    
    enum Action {
        case didSeleteStartTime(Date)
        case didSeleceEndTime(Date)
        case didSeleteColor(UIColor)
        case didTapSaveButton(String?, String?)
        case didSeleteAlarm(Alarm)
        case viewDidLoad
        case didTapAlldayButton
        case didTapKakaoButton
    }
    
    enum Mutation {
        case setTime(Date)
        case setEndTime(Date)
        case setColor(UIColor)
        case saveEvent
        case setAlarm(Alarm)
        case popAlert
    }
    
    struct State {
        var selectedDate: Date
        var selectedStartDate: Date
        var selectedEndDate: Date
        var selectedColor = DesignAsset.record.color
        var selectedAlarm: Alarm = .none
        
        var currentCalendarEvent: CalendarEvent
        
        @Pulse var isAlert = false
        @Pulse var saveEvent = false
    }

    let initialState: State
    
    init(seletedDate: Date, calendarEvent: CalendarEvent) {
        self.initialState = State(selectedDate: seletedDate, selectedStartDate: EventFixReactor.makeDefaultTime(date: seletedDate, hour: 8), selectedEndDate: EventFixReactor.makeDefaultTime(date: seletedDate, hour: 9), currentCalendarEvent: calendarEvent)
    }
    
    @Injected var saveEventUsecase: SaveEventUsecaseProtocol
    @Injected var deleteEventUsecase: DeleteEventUsecaseProtocol
    @Injected var kakaoSDKMessageUsecase: KakaoSDKMessageUsecaseProtocol
}
    
extension EventFixReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let setEndTime = Observable.just(Mutation.setEndTime(currentState.currentCalendarEvent.endDate))
            let setStartTime = Observable.just(Mutation.setTime(currentState.currentCalendarEvent.startDate))
            let setColor = Observable.just(Mutation.setColor(currentState.currentCalendarEvent.tagColor.toUIColor() ?? DesignAsset.record.color))
            
            let alarm = Alarm(rawValue: currentState.currentCalendarEvent.alarm ?? "알림 없음") ?? .none
            let setAlarm = Observable.just(Mutation.setAlarm(alarm))
            
            return Observable.concat([setEndTime, setStartTime, setColor, setAlarm])
        case .didSeleceEndTime(let date):
            return .just(.setEndTime(date))
        case .didSeleteStartTime(let date):
            if date < currentState.selectedEndDate {
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
                
                if checkDateValidation(startDate: self.currentState.selectedStartDate, endDate: self.currentState.selectedEndDate) {
                    observer.onNext(.popAlert)
                    return Disposables.create()
                }
                
                Task {
                    let event = EventBuilder()
                        .setAlarm(self.currentState.selectedAlarm)
                        .setDate(self.currentState.selectedStartDate)
                        .setEndDate(self.currentState.selectedEndDate)
                        .setTagColor(self.currentState.selectedColor.hexString)
                        .setTitle(title)
                        .setContent(content ?? "")
                        .build()
        
                    await self.fixEvent(event: event)
                    observer.onNext(.saveEvent)
                }
                return Disposables.create()
            }
            
//            if checkDateValidation(startDate: currentState.selectedStartDate, endDate: currentState.selectedEndDate) {
//                return .just(.popAlert)
//            }
//
//            let event = EventBuilder()
//                .setAlarm(currentState.selectedAlarm)
//                .setDate(currentState.selectedStartDate)
//                .setEndDate(currentState.selectedEndDate)
//                .setTagColor(currentState.selectedColor.hexString)
//                .setTitle(title)
//                .setContent(content ?? "")
//                .build()
//
//            fixEvent(event: event)
//
//            return .just(.saveEvent)
        case .didSeleteAlarm(let alarm):
            return .just(.setAlarm(alarm))
        case .didTapKakaoButton:
            kakaoSDKMessageUsecase.executePicker()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] message in
                    print(message)
                })
                
                
            return .empty()
            
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
        case .popAlert:
            newState.isAlert = true
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
extension EventFixReactor {
    static private func makeDefaultTime(date: Date, hour: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = 0

        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func checkDateValidation(startDate: Date, endDate: Date) -> Bool {
        return startDate > endDate
    }
    
    private func fixEvent(event: CalendarEvent) async {
        LocalPushService.shared.removeNotification(identifiers: [currentState.currentCalendarEvent.id])
        
        await saveEventUsecase.excecute(event: event)
        await deleteEventUsecase.execute(event: currentState.currentCalendarEvent)
        
        if event.alarm != .none {
            LocalPushService.shared.addNotification(
                identifier: event.id,
                title: event.title,
                body: event.content ?? "",
                date: Alarm(rawValue: event.alarm ?? Alarm.none.rawValue)?.timeBefore(from: event.startDate) ?? Date()
            )
        }
    }
}
