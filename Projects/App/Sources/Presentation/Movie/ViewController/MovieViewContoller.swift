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
    
    // MARK: Set
    override func setup() {
        view.backgroundColor = .white
        setNavigation()
    }
    
    private func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.navigationBar.tintColor = .recordColor
    }
    
    override func bind(reactor: MovieReactor) {
        bindInput(reactor: reactor)
    }
}

// MARK: - Bind
extension MovieViewContoller {
    
    private func bindInput(reactor: MovieReactor) {
        
        self.navigationItem.rightBarButtonItem?.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            
    }
}
