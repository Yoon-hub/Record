//
//  MetamonViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 9/29/25.
//

import UIKit

import Core

final class MetamonViewControllerWrapper: BaseWrapper {
    
    typealias R = MetamonReactor
    typealias V = MetamonViewController
    typealias C = MetamonView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return MetamonViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return MetamonReactor(initialState: MetamonReactor.State())
    }
    
    func makeView() -> C {
        return MetamonView()
    }

}
