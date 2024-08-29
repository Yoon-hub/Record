//
//  CalendarReactor.swift
//  App
//
//  Created by 윤제 on 8/12/24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class CalendarReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case didSelectDate(Date)
        case reloadEvents
        case didDeleteEvent(IndexPath)
    }
    
    enum Mutation {
        case setRestDate([RestDay])
        case setSelectDate(Date)
        case setEvents([CalendarEvent], Date)
    }
    
    struct State {
        var restDays: [RestDay] = []
        var events: [CalendarEvent] = []
        var selectedEvents: [CalendarEvent] = []
        var selectedDate: Date = Date()
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    @Injected var fetchRestDayFromDBUsecase: FetchRestDayFromDBUsecaserotocol
    @Injected var fetchEventUsecase: FetchEventUsecaseProtocol
    @Injected var deleteEventUsecase: DeleteEventUsecaseProtocol
    
}

extension CalendarReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let restDays = await self.fetchRestDayFromDBUsecase.execute()
                    observer.onNext(.setRestDate(restDays))
                }
                
                Task {
                    let events = await self.fetchEventUsecase.execute()
                    observer.onNext(.setEvents(events, self.currentState.selectedDate))
                }
                
                return Disposables.create()
            }
        case .didSelectDate(let date):
            return .just(.setSelectDate(date))
            
        case .reloadEvents:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }

                Task {
                    let events = await self.fetchEventUsecase.execute()
                    observer.onNext(.setEvents(events, self.currentState.selectedDate))
                }
                
                return Disposables.create()
            }
        case .didDeleteEvent(let indexPath):
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                
                self.deleteEventUsecase.execute(event: self.currentState.selectedEvents[indexPath.row])
                
                Task {
                    let events = await self.fetchEventUsecase.execute()
                    observer.onNext(.setEvents(events, self.currentState.selectedDate))
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
        case .setRestDate(let restDays):
            newState.restDays = restDays
            return newState
        case .setSelectDate(let date):
            newState.selectedDate = date
            newState.selectedEvents = filterEventsByDate(events: newState.events, date: date).sorted { $0.date < $1.date }
            return newState
        case .setEvents(let events, let date):
            newState.events = events
            newState.selectedEvents = filterEventsByDate(events: newState.events, date: date).sorted { $0.date < $1.date }
            return newState
        }
    }
}

extension CalendarReactor {
    private func filterEventsByDate(events: [CalendarEvent], date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        return events.filter { event in
            let eventDate = calendar.startOfDay(for: event.date)
            let targetDate = calendar.startOfDay(for: date)
            return eventDate == targetDate
        }
    }
}
