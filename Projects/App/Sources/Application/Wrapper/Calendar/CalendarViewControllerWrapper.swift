//
//  CalendarViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 8/12/24.
//

import UIKit

import Core

final class CalendarViewControllerWrapper: BaseWrapper {
    
    typealias R = CalendarReactor
    typealias V = CalendarViewController
    typealias C = CalendarView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return CalendarViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return CalendarReactor(initialState: CalendarReactor.State())
    }
    
    func makeView() -> C {
        return CalendarView()
    }

}
