//
//  MovieViewControllerWapper.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

import Core

final class MovieViewControllerWapper: BaseWrapper {
    
    typealias R = MovieReactor
    typealias V = MovieViewContoller
    typealias C = MovieView
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return MovieViewContoller(contentView: makeView(), reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return MovieReactor(initialState: MovieReactor.State())
    }
    
    func makeView() -> C {
        return MovieView()
    }

}
