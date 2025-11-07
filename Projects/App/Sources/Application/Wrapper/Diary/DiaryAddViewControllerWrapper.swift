//
//  DiaryAddViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Core

final class DiaryAddViewControllerWrapper: BaseWrapper {
    
    typealias R = DiaryAddReactor
    typealias V = DiaryAddViewController
    typealias C = DiaryAddView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return DiaryAddViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return DiaryAddReactor(initialState: DiaryAddReactor.State())
    }
    
    func makeView() -> C {
        return DiaryAddView()
    }
}

