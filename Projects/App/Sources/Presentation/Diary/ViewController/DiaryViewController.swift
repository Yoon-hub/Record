//
//  DiaryViewController.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Core
import Domain

import ReactorKit
import RxSwift
import RxCocoa
import RxKeyboard

final class DiaryViewController: BaseViewController<DiaryReactor, DiaryView> {
    
    @Navigator var navigator: DiaryNavigatorProtocol
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    // MARK: Set
    override func setup() {
        setNavigation()
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bind(reactor: DiaryReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: DiaryReactor) {
        
        contentView.diaryBackButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        // 테이블뷰 아이템 선택
        contentView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.contentView.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: DiaryReactor) {
        // 일기 목록 업데이트
        reactor.state
            .map { $0.diaries }
            .distinctUntilChanged()
                .observe(on: MainScheduler.instance)
            .bind(to: contentView.tableView.rx.items(
                cellIdentifier: DiaryTableViewCell.identifier,
                cellType: DiaryTableViewCell.self
            )) { [weak self] index, diary, cell in
                cell.bind(diary)

            }
            .disposed(by: disposeBag)
        
        
        // 빈 상태 표시/숨김
        reactor.state
            .map { $0.diaries.isEmpty }
            .distinctUntilChanged()
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: contentView.emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
}

