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
        setNavigation()
    }
    
    private func setNavigation() {
        let deleteMenuItem = UIAction(title: "삭제", image: UIImage(systemName: "trash")) { [weak self] action in
            self?.reactor?.action.onNext(.didTapDeleteButton)
        }
        
        let menu = UIMenu(image: UIImage(systemName: "ellipsis.circle"), children: [deleteMenuItem])
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        
        self.navigationItem.rightBarButtonItem = barButtonItem
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
        
        reactor.pulse(\.$showAlert)
            .compactMap{$0}
            .withUnretained(self)
            .bind { $0.0.showSaveAlert(text: $0.1) }
            .disposed(by: disposeBag)
    }
}


// MARK: -
extension MovieDetailViewController {
    private func showSaveAlert(text: String) {
        self.showAlert(title: "알림", message: text) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
