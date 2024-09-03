//
//  EventAddViewController.swift
//  App
//
//  Created by 윤제 on 8/20/24.
//

import UIKit

import Core
import Design

import PinLayout
import ReactorKit
import RxKeyboard

final class EventAddViewController: BaseViewController<EventAddReactor, EventAddView> {
    
    let customPopView = CustomPopView()
    
    let reloadTableView: (() -> Void)?
    
    init(contentView: EventAddView, reactor: EventAddReactor, reloadTableView: @escaping (() -> Void)) {
        self.reloadTableView = reloadTableView
        super.init(contentView: contentView, reactor: reactor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
   }
    
    override func setup() {
        setAlarmButtonMenu()
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
        contentView.startTimeButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.view.endEditing(true)
                $0.0.customPopView.show($0.0)
                let datePickerView = DatePickerView(frame: .zero, seletedDate: reactor.currentState.selectedStartDate)
                datePickerView.completionHandler = {
                    [weak self] date in self?.customPopView.hide()
                    self?.reactor?.action.onNext(.didSeleteStartTime(date))
                }
                $0.0.customPopView.contentView = datePickerView
            }
            .disposed(by: disposeBag)
        
        contentView.endTimeButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.view.endEditing(true)
                $0.0.customPopView.show($0.0)
                let datePickerView = DatePickerView(frame: .zero, seletedDate: reactor.currentState.selectedEndDate)
                datePickerView.completionHandler = {
                    [weak self] date in self?.customPopView.hide()
                    self?.reactor?.action.onNext(.didSeleceEndTime(date))
                }
                $0.0.customPopView.contentView = datePickerView
            }
            .disposed(by: disposeBag)
        
        contentView.tagButton.rx.controlEvent(.allEvents)
            .withUnretained(self)
            .map { Reactor.Action.didSeleteColor($0.0.contentView.tagButton.selectedColor ?? DesignAsset.record.color)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.saveButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { Reactor.Action.didTapSaveButton($0.0.contentView.titleTextField.text, $0.0.contentView.textView.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: EventAddReactor) {
        
        reactor.state.map { $0.selectedStartDate }
            .withUnretained(self)
            .bind { $0.0.contentView.startTimeButton.setTitle("\($0.1.formattedDateString(type: .yearMonthDayTime))", for: .normal) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedEndDate }
            .withUnretained(self)
            .bind { $0.0.contentView.endTimeButton.setTitle("\($0.1.formattedDateString(type: .yearMonthDayTime))", for: .normal) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedColor }
            .withUnretained(self)
            .bind { $0.0.contentView.titleTagColor.backgroundColor = $0.1 }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedAlarm }
            .withUnretained(self)
            .bind { $0.0.contentView.alarmButton.setTitle($0.1.rawValue, for: .normal) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$saveEvent)
            .withUnretained(self)
            .bind {
                $0.0.dismiss(animated: true)
                $0.0.reloadTableView?()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isAlert)
            .withUnretained(self)
            .bind {
                $0.0.showAlert(title: "알림", message: "시작 날짜는 종료 날짜 이전이어야 합니다.")
            }
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
    
    
    private func setAlarmButtonMenu() {
        let timeOptions = Reactor.Alarm.allCases
        
        let actions = timeOptions.map { alarm in
            return UIAction(title: alarm.rawValue) { [weak self] _ in
                self?.reactor?.action.onNext(.didSeleteAlarm(alarm))
            }
        }
        
        let menu = UIMenu(children: actions)
        
        contentView.alarmButton.showsMenuAsPrimaryAction = true
        contentView.alarmButton.menu = menu
    }
}
