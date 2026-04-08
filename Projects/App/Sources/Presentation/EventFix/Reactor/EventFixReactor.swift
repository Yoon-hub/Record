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
import KakaoSDKCommon

final class EventFixReactor: Reactor {
    
    typealias Alarm = CalendarEvent.Alarm
    
    enum Action {
        case didSeleteStartTime(Date)
        case didSeleceEndTime(Date)
        case didSeleteColor(UIColor)
        case didTapSaveButton(String?, String?)
        case didSeleteAlarm(Alarm)
        case didTapAlldayButton
        case didTapKakaoButton
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
        var selectedColor = Theme.theme
        var selectedAlarm: Alarm = .none
        var selectedRecurrence: EventRecurrenceOption = .none
        
        var currentCalendarEvent: CalendarEvent
        
        @Pulse var isAlert = ""
        @Pulse var saveEvent = false
    }

    let initialState: State
    
    init(seletedDate: Date, calendarEvent: CalendarEvent) {
        let start = calendarEvent.displayStartDate(forCalendarDay: seletedDate)
        let end = calendarEvent.displayEndDate(forCalendarDay: seletedDate)
        let alarm = Alarm(rawValue: calendarEvent.alarm ?? "알림 없음") ?? .none
        self.initialState = State(
            selectedDate: seletedDate,
            selectedStartDate: start,
            selectedEndDate: end,
            selectedColor: calendarEvent.tagColor.toUIColor() ?? Theme.theme,
            selectedAlarm: alarm,
            selectedRecurrence: EventRecurrenceOption.from(calendarEvent),
            currentCalendarEvent: calendarEvent
        )
    }
    
    @Injected var saveEventUsecase: SaveEventUsecaseProtocol
    @Injected var deleteEventUsecase: DeleteEventUsecaseProtocol
    @Injected var kakaoSDKMessageUsecase: KakaoSDKMessageUsecaseProtocol
}
    
extension EventFixReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
                
                if self.checkDateValidation(startDate: self.currentState.selectedStartDate, endDate: self.currentState.selectedEndDate) {
                    observer.onNext(.popAlert("시작 날짜는 종료 날짜 이전이어야 합니다."))
                    return Disposables.create()
                }
                
                if self.currentState.selectedRecurrence != .none,
                   !Calendar.current.isDate(self.currentState.selectedStartDate, inSameDayAs: self.currentState.selectedEndDate) {
                    observer.onNext(.popAlert("반복 일정은 같은 날 안에서 끝나는 일정만 설정할 수 있어요."))
                    return Disposables.create()
                }
                
                Task {
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
        case .didSelectRecurrence(let option):
            return .just(.setRecurrence(option))
        case .didTapKakaoButton:
            return kakaoSDKMessageUsecase.executeShareCustomContent(args:
                                                                ["title" : currentState.currentCalendarEvent.title,
                                                                 "content": "일정: \(currentState.currentCalendarEvent.startDate.formattedDateString(type: .simpleDate)) ~ \(currentState.currentCalendarEvent.endDate.formattedDateString(type: .simpleDate))",
                                                                 "body": currentState.currentCalendarEvent.content ?? "",
                                                                 "tagColor": currentState.currentCalendarEvent.tagColor.replacingOccurrences(of: "#", with: ""),
                                                                 "startDate": currentState.currentCalendarEvent.startDate.toString(),
                                                                 "endDate": currentState.currentCalendarEvent.endDate.toString(),
                                                                 "alarm": currentState.currentCalendarEvent.alarm ?? CalendarEvent.Alarm.none.rawValue
                                                                ]
            )
            .observe(on: MainScheduler.instance)
            .flatMap { (sharingResult) in
                UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                return Observable<Mutation>.empty()
            }
            .catch { _ in
                return Observable<Mutation>.just(.popAlert("카카오톡 로그인 후 사용해 주세요."))
            }
            
            
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
        case .popAlert(let text):
            newState.isAlert = text
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
        
        let alarm = Alarm(rawValue: event.alarm ?? Alarm.none.rawValue) ?? .none
        EventNotificationScheduler.reschedule(
            event: event,
            alarm: alarm,
            recurrence: EventRecurrenceOption.from(event),
            templateStartDate: event.startDate
        )
    }
}
