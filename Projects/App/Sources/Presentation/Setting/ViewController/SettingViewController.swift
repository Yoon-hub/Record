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
    
    @Injected var provider: GlobalStateProvider
    
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
            .bind(to: contentView.tableView.rx.items(
                cellIdentifier: SettingTableViewCell.identifier,
                cellType: SettingTableViewCell.self)
            ) { _, item, cell in
                cell.titleLabel.text = item.title
                self.setItemContentLabelText(item: item, cell: cell)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: -
extension SettingViewController {
    
    private func setItemContentLabelText(
        item: Reactor.SettingList,
        cell: SettingTableViewCell
    ) {
        /// 공휴일 업데이트
        if item == .restDayUpdate { cell.contentLabel.text = "" }
        
        /// 버전 정보
        if item == .version { cell.contentLabel.text = "1.0" }
        
        /// 시작 날짜 선택
        if item == .firstWeekday {
            
            let firstWeedDay = UserDefaultsWrapper.firstWeekday == "" ? "2" : UserDefaultsWrapper.firstWeekday
            cell.contentLabel.text = SettingReactor.SettingList.FirstWeekday.title(firstWeedDay)
        }
    }
    
    private func handleItemSelected(setting: Reactor.SettingList) {
        switch setting {
        case .version:
            print("alarm")
            
        case .restDayUpdate:
            showAlert(title: "공휴일 정보를 업데이트 하시겠습니까?", message: "임시 공휴일 등 새로운 정보를 받을 수 있어요.", cancel: true) { [weak self] in
                guard let self else {return}
                self.reactor?.action.onNext(.restDayUpdateTapped)
                self.downlaodAnimation()
            }
        case .firstWeekday:
            UserDefaultsWrapper.firstWeekday = UserDefaultsWrapper.firstWeekday == "1" ? "2" : "1"
            provider.sendEvent(.caldenarUIUpdate)
            
            /// 진동
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
            
            self.contentView.tableView.reloadData()
        }
    }
    
    private func downlaodAnimation() {
        let animationView = self.contentView.animationView
        animationView.play()
        animationView.alpha = 1
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            animationView.stop()
            animationView.alpha = 0
            
            self.showAlert(title: "공휴일 정보가 업데이트 되었습니다!", message: nil)
            
            self.view.isUserInteractionEnabled = true
        }
    }
}
    
