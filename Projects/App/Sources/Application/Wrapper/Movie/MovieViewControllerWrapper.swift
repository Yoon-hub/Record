//
//  MovieViewControllerWapper.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

import Core

final class MovieViewControllerWrapper: BaseWrapper {
    
    typealias R = MovieReactor
    typealias V = MovieViewContoller
    typealias C = MovieView
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return MovieViewContoller(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return MovieReactor(initialState: MovieReactor.State())
    }
    
    func makeView() -> C {
        return MovieView()
    }

}
