//
//  MovieAddViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import UIKit

import Core

final class MovieAddViewControllerWrapper: BaseWrapper {
    
    typealias R = MovieAddReactor
    typealias V = MovieAddViewController
    typealias C = MovieAddView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return MovieAddViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return MovieAddReactor(initialState: MovieAddReactor.State())
    }
    
    func makeView() -> C {
        return MovieAddView()
    }
}
