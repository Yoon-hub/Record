//
//  EventAddViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 8/20/24.
//

import UIKit

import Core

final class EventAddViewControllerWrapper: BaseWrapper {
    
    typealias R = EventAddReactor
    typealias V = EventAddViewController
    typealias C = EventAddView
    
    // MARK: - Make
    
    let seletedDate: Date
    
    let reloadTableView: (() -> Void)
    
    init(seletedDate: Date, reloadTableView: @escaping (() -> Void)) {
        self.seletedDate = seletedDate
        self.reloadTableView = reloadTableView
    }
    
    func makeViewController() -> V {
        return EventAddViewController(contentView: view, reactor: reactor, reloadTableView: reloadTableView)
    }
    
    func makeReactor() -> R {
        return EventAddReactor(seletedDate: seletedDate)
    }
    
    func makeView() -> C {
        return EventAddView()
    }

}

