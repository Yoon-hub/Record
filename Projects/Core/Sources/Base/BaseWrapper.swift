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
    
    func makeReactor() -> R
    func makeViewController() -> V
    
    var reactor: R { get }
    var viewController: V { get }
    
}
