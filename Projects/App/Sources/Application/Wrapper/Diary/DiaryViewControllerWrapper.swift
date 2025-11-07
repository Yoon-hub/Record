//
//  DiaryViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Core

final class DiaryViewControllerWrapper: BaseWrapper {
    
    typealias R = DiaryReactor
    typealias V = DiaryViewController
    typealias C = DiaryView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return DiaryViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return DiaryReactor(initialState: DiaryReactor.State())
    }
    
    func makeView() -> C {
        return DiaryView()
    }
}



