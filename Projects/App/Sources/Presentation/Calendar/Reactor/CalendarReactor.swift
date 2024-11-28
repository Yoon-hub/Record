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
        case undoDeleteEvent
    }
    
    enum Mutation {
        case setRestDate([RestDay])
        case setSelectDate(Date)
        case setSelectedEvents([CalendarEvent])
        case setEvents([CalendarEvent], Date)
        case setToast(String)
        case calendarUIUpdate
    }
    
    struct State {
        var restDays: [RestDay] = []
        var events: [CalendarEvent] = []
        var selectedEvents: [CalendarEvent] = []
        var selectedDate: Date = Date()
        
        @Pulse var isToast: String = ""
        @Pulse var calendarUIUpdate = true
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    @Injected var fetchRestDayFromDBUsecase: FetchRestDayFromDBUsecaserotocol
    @Injected var fetchEventUsecase: FetchEventUsecaseProtocol
    @Injected var deleteEventUsecase: DeleteEventUsecaseProtocol
    @Injected var saveEventUsecsae: SaveEventUsecaseProtocol
    
    /// Globar State
    @Injected var provider: GlobalStateProvider
    
    /// 삭제 취소를 윈한 변수
    private var undoEvent: CalendarEvent?
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
                    
                    let events = await self.fetchEventUsecase.execute()
                    observer.onNext(.setEvents(events, self.currentState.selectedDate))
                }
                
                return Disposables.create()
            }
        case .didSelectDate(let date):
            let setDateMutation = Observable.just(Mutation.setSelectDate(date))
            let updateEventsMutation = Observable.just(Mutation.setSelectedEvents(filterEventsByDate(events: currentState.events, date: date).sorted { $0.startDate < $1.startDate }))
            
            return Observable.concat([setDateMutation, updateEventsMutation])
            
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
                
                let selectedEvent = self.currentState.selectedEvents[indexPath.row]
                self.undoEvent = selectedEvent
                
                Task {
                    await self.deleteEventUsecase.execute(event: selectedEvent)
                    let events = await self.fetchEventUsecase.execute()
                    observer.onNext(.setEvents(events, self.currentState.selectedDate))
                    observer.onNext(.setToast("삭제 되돌리기"))
                }
                
                return Disposables.create()
            }
        case .undoDeleteEvent:
            return Observable.create { [weak self] observer in
                guard let self, let undoEvent else { return Disposables.create() }
                Task {
                    await self.saveEventUsecsae.excecute(event: undoEvent)
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
            return newState
        case .setSelectedEvents(let events):
            newState.selectedEvents = events
            return newState
        case .setEvents(let events, let date):
            newState.events = events
            newState.selectedEvents = filterEventsByDate(events: newState.events, date: date).sorted { $0.startDate < $1.startDate }
            return newState
        case .setToast(let message):
            newState.isToast = message
            return newState
        case .calendarUIUpdate:
            newState.calendarUIUpdate = true
            return newState
        }
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let uiUpdateMutation = provider.event
            .flatMap { event in
                switch event {
                case .caldenarUIUpdate:
                    return Observable<Mutation>.just(.calendarUIUpdate)
                }
            }
        return Observable.merge(mutation, uiUpdateMutation)
    }
}

extension CalendarReactor {
    func filterEventsByDate(events: [CalendarEvent], date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        
        return events.filter { event in
            let eventStartDate = calendar.startOfDay(for: event.startDate)
            let eventEndDate = calendar.startOfDay(for: event.endDate)
            let targetDate = calendar.startOfDay(for: date)
            
            return eventStartDate <= targetDate && targetDate <= eventEndDate
        }
    }
}
