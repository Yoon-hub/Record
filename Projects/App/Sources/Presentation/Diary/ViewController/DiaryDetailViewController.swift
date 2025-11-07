//
//  DiaryDetailViewController.swift
//  App
//
//  Created by 윤제 on 1/13/25.
//

import UIKit

import Core
import Domain

import ReactorKit
import RxSwift
import RxCocoa

final class DiaryDetailViewController: BaseViewController<DiaryDetailReactor, DiaryDetailView> {
    
    @Navigator var navigator: DiaryNavigatorProtocol
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    // MARK: Set
    override func setup() {
        setNavigation()
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bind(reactor: DiaryDetailReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: DiaryDetailReactor) {
        // 필요 시 입력 바인딩 추가
        
        contentView.diaryBackButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: DiaryDetailReactor) {
        // 일기 데이터 업데이트
        reactor.state
            .map { $0.diary }
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] diary in
                self?.contentView.updateContent(diary: diary)
            })
            .disposed(by: disposeBag)
    }
}

