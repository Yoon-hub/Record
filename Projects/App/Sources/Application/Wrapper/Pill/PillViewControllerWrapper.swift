//
//  PillViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import UIKit

import Core

final class PillViewControllerWrapper: BaseWrapper {
    
    typealias R = PillReactor
    typealias V = PillViewController
    typealias C = PillView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return PillViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return PillReactor()
    }
    
    func makeView() -> C {
        return PillView()
    }

}

