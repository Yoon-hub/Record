//
//  EventFixViewController.swift
//  App
//
//  Created by 윤제 on 9/3/24.
//

import UIKit

import Core
import Design
import Domain

import PinLayout
import ReactorKit
import RxKeyboard

import KakaoSDKTalk
import KakaoSDKAuth

final class EventFixViewController: BaseViewController<EventFixReactor, EventAddView> {
    
    @Injected var kakaoSDKMessageUsecase: KakaoSDKMessageUsecaseProtocol
    
    let customPopView = CustomPopView()
    
    let reloadTableView: (() -> Void)?
    
    init(
        contentView: EventAddView,
        reactor: EventFixReactor,
        reloadTableView: @escaping (() -> Void)
    ) {
        self.reloadTableView = reloadTableView
        super.init(contentView: contentView, reactor: reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
   }
    
    override func setup() {
        setAlarmButtonMenu()
        showKakaoMessageButton()
    }
    
    override func bind(reactor: EventFixReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
        changeSaveButotnLayout()
    }
}


// MARK: - Bind
extension EventFixViewController {
    private func bindInput(reactor: EventFixReactor) {
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
        
        contentView.allDayButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapAlldayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.kakaoSDKButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapKakaoButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: EventFixReactor) {
        
        reactor.state.map { $0.selectedStartDate }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.contentView.startTimeButton.setTitle("\($0.1.formattedDateString(type: .yearMonthDayTime))", for: .normal) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedEndDate }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.contentView.endTimeButton.setTitle("\($0.1.formattedDateString(type: .yearMonthDayTime))", for: .normal) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedColor }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.contentView.titleTagColor.backgroundColor = $0.1
                $0.0.contentView.tagButton.selectedColor = $0.1
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedAlarm }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.contentView.alarmButton.setTitle($0.1.rawValue, for: .normal) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$saveEvent)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.dismiss(animated: true)
                $0.0.reloadTableView?()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isAlert)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.showAlert(
                    title: "알림",
                    message: $0.1
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentCalendarEvent }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.contentView.titleTextField.text = $0.1.title
                $0.0.contentView.textView.text = $0.1.content
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedStartDate}
            .observe(on: MainScheduler.instance)
            .map {
                $0 == EventAddReactor.makeDefaultTime(date: reactor.currentState.selectedDate, hour: 0) &&
                reactor.currentState.selectedEndDate == EventAddReactor.makeDefaultTime(date: reactor.currentState.selectedDate, hour: 23, minute: 59)
            }
            .withUnretained(self)
            .bind {  $0.1 ? $0.0.contentView.allDayButton.setTitleColor(.black, for: .normal) : $0.0.contentView.allDayButton.setTitleColor(.systemGray, for: .normal)}
            .disposed(by: disposeBag)
    }
}

// MARK: - userDefine
extension EventFixViewController {
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
    
    /// 카카오 메세지 버튼 노출
    private func showKakaoMessageButton() {
        contentView.kakaoSDKButton.isHidden = false
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

