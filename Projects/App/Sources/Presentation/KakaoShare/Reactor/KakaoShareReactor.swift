//
//  KakaoShareReactor.swift
//  App
//
//  Created by 윤제 on 1/15/25.
//

import UIKit

import Core
import Domain

import ReactorKit

final class KakaoShareReactor: Reactor {
    
    enum Action {
        case didTapSave
    }
    
    enum Mutation {
        case saveEvent
    }
    
    struct State {
        let kakaoEvent: CalendarEvent
        
        @Pulse var isSaveEvent = false
    }
    
    var initialState: State
    
    init(kakaoEvent: CalendarEvent) {
        self.initialState = State(kakaoEvent: kakaoEvent)
    }
    
    @Injected var saveEventUsecase: SaveEventUsecaseProtocol
}

extension KakaoShareReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapSave:
            return Observable.create { [weak self] observer in
                guard let self else {return Disposables.create()}
                
                Task {
                    let event = self.currentState.kakaoEvent
                    let alarmDate = CalendarEvent.Alarm(rawValue: event.alarm ?? CalendarEvent.Alarm.none.rawValue)?
                        .timeBefore(from: event.startDate) ?? Date()
                    
                    await self.saveEventUsecase.excecute(event: event)
                    
                    if event.alarm != .none {
                        LocalPushService.shared.addNotification(
                            identifier: event.id,
                            title: event.title,
                            body: event.content ?? "",
                            date: alarmDate)
                    }
                    
                    observer.onNext(.saveEvent)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .saveEvent:
            newState.isSaveEvent = true
        }
        
        return newState
    }
}
