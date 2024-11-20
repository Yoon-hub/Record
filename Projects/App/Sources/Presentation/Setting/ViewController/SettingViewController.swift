//
//  SettingViewController.swift
//  App
//
//  Created by 윤제 on 11/19/24.
//

import UIKit

import Core

import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController<SettingReactor, SettinView> {
    
    override func setup() {
        setNavigation()
    }
    
    // MARK: - Navigation
    private func setNavigation() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "설정"
    }
    
    override func bind(reactor: SettingReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
}

// MARK: - Bind
extension SettingViewController {
    private func bindInput(reactor: Reactor) {
        contentView.tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { (vc, index) in
                let setting = reactor.currentState.settingList[index.row]
                vc.handleItemSelected(setting: setting)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: Reactor) {
        reactor.state.map {$0.settingList}
            .bind(to: contentView.tableView.rx.items(cellIdentifier: SettingTableViewCell.identifier, cellType: SettingTableViewCell.self)
            ) { _, item, cell in
                cell.titleLabel.text = item.title
            }
            .disposed(by: disposeBag)
    }
}

// MARK:
extension SettingViewController {
    private func handleItemSelected(setting: Reactor.SettingList) {
        switch setting {
            
        case .pillAlarm:
            print("alarm")
            
        case .restDayUpdate:
            showAlert(title: "공휴일 정보를 업데이트 하시겠습니까?", message: "임시 공휴일 등 새로운 정보를 받을 수 있어요.", cancel: true) { [weak self] in
                guard let self else {return}
                self.reactor?.action.onNext(.restDayUpdateTapped)
            }
            
        }
    }
}
