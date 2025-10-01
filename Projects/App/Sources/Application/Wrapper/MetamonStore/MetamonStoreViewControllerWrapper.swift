//
//  MetamonStoreViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 10/1/25.
//

import Foundation

import Core

final class MetamonStoreViewControllerWrapper: BaseWrapper {
    
    typealias R = MetamonStoreReactor
    typealias V = MetamonStoreViewController
    typealias C = MetamonStoreView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return MetamonStoreViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return MetamonStoreReactor(initialState: MetamonStoreReactor.State())
    }
    
    func makeView() -> C {
        return MetamonStoreView()
    }

}
