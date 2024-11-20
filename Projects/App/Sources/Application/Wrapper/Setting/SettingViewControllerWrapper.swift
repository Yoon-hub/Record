//
//  SettingViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 11/20/24.
//

import Foundation

import Core

final class SettingViewControllerWrapper: BaseWrapper {
    
    typealias R = SettingReactor
    typealias V = SettingViewController
    typealias C = SettinView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return SettingViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return SettingReactor()
    }
    
    func makeView() -> C {
        return SettinView()
    }
    
}
