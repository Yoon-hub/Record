//
//  EventFixViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 9/3/24.
//

import UIKit

import Core
import Domain

final class EventFixViewControllerWrapper: BaseWrapper {
    
    typealias R = EventFixReactor
    typealias V = EventFixViewController
    typealias C = EventAddView
    
    // MARK: - Make
    
    let seletedDate: Date
    
    let reloadTableView: (() -> Void)
    
    let currentEvent: CalendarEvent
    
    init(seletedDate: Date,  currentEvent: CalendarEvent, reloadTableView: @escaping (() -> Void)) {
        self.seletedDate = seletedDate
        self.reloadTableView = reloadTableView
        self.currentEvent = currentEvent
    }
    
    func makeViewController() -> V {
        return EventFixViewController(contentView: view, reactor: reactor, reloadTableView: reloadTableView)
    }
    
    func makeReactor() -> R {
        return EventFixReactor(seletedDate: seletedDate, calendarEvent: currentEvent)
    }
    
    func makeView() -> C {
        return EventAddView()
    }

}
