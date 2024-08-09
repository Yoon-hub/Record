//
//  MovieViewContoller.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

import Core

import ReactorKit
import RxSwift
import RxCocoa

final class MovieViewContoller: BaseViewController<MovieReactor, MovieView> {
    
    @Navigator var navigator: MainNaviagatorProtocol
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    // MARK: Set
    override func setup() {
        view.backgroundColor = .white
        setNavigation()
    }
    
    private func setNavigation() {
        self.navigationController?.navigationBar.tintColor = .recordColor
        self.title = "보관함"
    }
    
    override func beforeBind() {
        makeNavigationItem()
    }
    
    override func bind(reactor: MovieReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func makeNavigationItem() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

// MARK: - Bind
extension MovieViewContoller {
    private func bindInput(reactor: MovieReactor) {
        self.navigationItem.rightBarButtonItem?.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.openNextView(.didTapRightBarButtonItem) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { $0.0.navigator.toMovieDetail(movie: reactor.currentState.movieItems[$0.1.row]) }
            .disposed(by: disposeBag)
        
        NotificationCenterService.reloadMoive.addObserver()
            .map {_ in Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MovieReactor) {
        reactor.pulse(\.$openNextView)
            .compactMap { $0 }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { $0.0.openNextView($0.1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.movieItems }
            .bind(to: contentView.collectionView.rx.items(
                cellIdentifier: MainCollectionViewCell.identifier,
                cellType: MainCollectionViewCell.self)
            ) { _, item, cell in
                cell.bind(item)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.movieItems }
            .map { $0.isEmpty }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { $0.0.contentView.emptyLabel.isHidden = !$0.1 }
            .disposed(by: disposeBag)
    }
}

// MARK: -
extension MovieViewContoller {
    private func openNextView(_ nextView: MovieReactor.TranstionTo) {
        switch nextView {
        case .addMovie:
            navigator.toMovieAdd()
        }
    }
}
