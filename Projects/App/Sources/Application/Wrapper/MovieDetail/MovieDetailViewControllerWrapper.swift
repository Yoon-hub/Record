//
//  MovieDetailViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 7/31/24.
//

import UIKit

import Core
import Domain

final class MovieDetailViewControllerWrapper: BaseWrapper {
    
    typealias R = MovieDetailReactor
    typealias V = MovieDetailViewController
    typealias C = MovieDetailView
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    let movie: Movie
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return V(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return R(initialState: R.State(movie: self.movie))
    }
    
    func makeView() -> C {
        return C()
    }

}

