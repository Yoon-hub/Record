//
//  MovieDetailViewController.swift
//  App
//
//  Created by 윤제 on 7/31/24.
//

import UIKit

import Core
import Design

import ReactorKit
import RxSwift
import RxCocoa

final class MovieDetailViewController: BaseViewController<MovieDetailReactor, MovieDetailView> {
    
    override func bind(reactor: MovieDetailReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        contentView.bind(movie: reactor!.currentState.movie)
    }
}

// MARK: - Bind
extension MovieDetailViewController {
    private func bindInput(reactor: MovieDetailReactor) {
        
    }
    
    private func bindOutput(reactor: MovieDetailReactor) {
        reactor.state.map { $0.movie.image }
            .bind(to: contentView.focusCollectionView.rx.items(
                cellIdentifier: MovieDetailCollectionViewCell.identifier,
                cellType: MovieDetailCollectionViewCell.self)
            ) { _, item, cell in
                cell.bind(image: item.toImage())
            }
            .disposed(by: disposeBag)
        
        
    }
}
