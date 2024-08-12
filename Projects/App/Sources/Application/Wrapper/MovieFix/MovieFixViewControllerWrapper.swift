//
//  MovieFixViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 8/9/24.
//

import Foundation

import Core
import Domain

final class MovieFixViewControllerWrapper: BaseWrapper {
    
    typealias R = MovieFixReactor
    typealias V = MovieFixViewController
    typealias C = MovieAddView
    
    let movie: Movie
    
    var completion: (() -> Void)
    
    init(movie: Movie, completion: @escaping (() -> Void)) {
        self.movie = movie
        self.completion = completion
    }
    
    // MARK: - Make
    
    func makeViewController() -> V {
        let vc = MovieFixViewController(contentView: view, reactor: reactor)
        vc.completion = completion
        return vc
    }
    
    func makeReactor() -> R {
        return MovieFixReactor(initialState: MovieFixReactor.State(movie: movie))
    }
    
    func makeView() -> C {
        return MovieAddView()
    }
}
