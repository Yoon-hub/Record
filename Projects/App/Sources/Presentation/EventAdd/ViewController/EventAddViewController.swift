//
//  EventAddViewController.swift
//  App
//
//  Created by 윤제 on 8/20/24.
//

import UIKit

import Core

import PinLayout
import ReactorKit
import RxKeyboard

final class EventAddViewController: BaseViewController<EventAddReactor, EventAddView> {
    
    let customPopView = CustomPopView()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
   }
    
    override func bind(reactor: EventAddReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
        changeSaveButotnLayout()
    }
}

// MARK: - Bind
extension EventAddViewController {
    private func bindInput(reactor: EventAddReactor) {
        contentView.timeButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.customPopView.show($0.0)
                let datePickerView = DatePickerView(frame: .zero, seletedDate: reactor.currentState.selectedTime)
                datePickerView.completionHandler = {
                    [weak self] date in self?.customPopView.hide()
                    self?.reactor?.action.onNext(.didSeleteTime(date))
                }
                $0.0.customPopView.contentView = datePickerView
            }
            .disposed(by: disposeBag)
        
        contentView.tagButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.present(UIColorPickerViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: EventAddReactor) {
        
        reactor.state.map { $0.selectedTime }
            .withUnretained(self)
            .bind { $0.0.contentView.timeButton.setTitle("\($0.1.formatToTime())", for: .normal) }
            .disposed(by: disposeBag)
    }
}

// MARK: - userDefine
extension EventAddViewController {
    private func changeSaveButotnLayout() {
        RxKeyboard.instance.visibleHeight
                   .drive(onNext: { [weak self] keyboardHeight in
                       guard let self else { return }
                       
                       if keyboardHeight > 0 {
                           self.contentView.saveButton.pin
                               .bottom(contentView.pin.safeArea.bottom)
                               .marginBottom(keyboardHeight)
                               .right(20)
                               .size(54)
                       } else {
                           self.contentView.saveButton.pin
                               .bottom(contentView.pin.safeArea.bottom)
                               .marginBottom(30)
                               .right(20)
                               .size(54)
                       }

                       UIView.animate(withDuration: 0.3) {
                           self.contentView.layoutIfNeeded()
                       }
                   })
                   .disposed(by: disposeBag)
    }
    
}
