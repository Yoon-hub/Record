//
//  SettingViewController.swift
//  App
//
//  Created by 윤제 on 11/19/24.
//

import UIKit

import Core

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
        
    }
    
    private func bindOutput(reactor: Reactor) {
        reactor.state.map {$0.settingList}
            .bind(to: contentView.tableView.rx.items(cellIdentifier: SettingTableViewCell.identifier, cellType: SettingTableViewCell.self)
            ) { _, item, cell in
                cell.titleLabel.text = item
            }
            .disposed(by: disposeBag)
    }
}


