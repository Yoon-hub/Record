//
//  BaseWrapper.swift
//  Core
//
//  Created by 윤제 on 7/8/24.
//

import UIKit

import ReactorKit

public protocol BaseWrapper {
    
    associatedtype R: Reactor
    associatedtype V: ReactorKit.View
    associatedtype C: BaseView
    
    func makeReactor() -> R
    func makeViewController() -> V
    func makeView() -> C
    
    var reactor: R { get }
    var viewController: V { get }
    
}

public extension BaseWrapper {
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
    
    var view: C {
        makeView()
    }
}
