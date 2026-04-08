//
//  EventSearchViewControllerWrapper.swift
//  App
//

import Foundation

import Core

final class EventSearchViewControllerWrapper: BaseWrapper {
    
    typealias R = EventSearchReactor
    typealias V = EventSearchViewController
    typealias C = EventSearchView
    
    func makeViewController() -> V {
        EventSearchViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        EventSearchReactor()
    }
    
    func makeView() -> C {
        EventSearchView()
    }
}
