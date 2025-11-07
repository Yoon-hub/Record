//
//  DiaryAddViewController.swift
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

final class DiaryAddViewController: BaseViewController<DiaryAddReactor, DiaryAddView>, UITextViewDelegate {
    
    @Navigator var navigator: DiaryNavigatorProtocol
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Set
    override func setup() {
        setNavigation()
        contentView.textView.delegate = self
        contentView.textView.becomeFirstResponder()
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bind(reactor: DiaryAddReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
        bindKeyboard()
    }
    
    private func bindInput(reactor: DiaryAddReactor) {
         // 키보드 위 닫기 버튼
        contentView.keyboardCloseButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 키보드 위 완료 버튼
        contentView.keyboardCompleteButton.rx.tap
            .map { [weak self] _ -> String in
                return self?.contentView.textView.text ?? ""
            }
            .map { Reactor.Action.saveDiary(content: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: DiaryAddReactor) {
        // 에러 메시지 표시
        reactor.pulse(\.$errorMessage)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(
                    title: "일기 추가 불가",
                    message: message,
                    cancel: false
                ){}
            })
            .disposed(by: disposeBag)
        
        // 저장 성공 시 화면 닫기
        reactor.pulse(\.$isSaveSuccess)
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITextViewDelegate
    // 들여쓰기 기능을 위해 return 키 처리를 제거
    
    // MARK: - Keyboard Handling
    private func bindKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                
                let bottomInset: CGFloat
                if keyboardHeight > 0 {
                    // 키보드가 올라왔을 때: 키보드 높이만큼 bottom inset 설정
                    bottomInset = keyboardHeight
                } else {
                    // 키보드가 내려갔을 때: 기본 여백
                    let verticalMargin: CGFloat = self.view.bounds.height * 0.05
                    bottomInset = verticalMargin
                }
                
                let horizontalMargin: CGFloat = self.view.bounds.width * 0.05
                let topMargin: CGFloat = 120
                
                self.contentView.textView.pin
                    .left(horizontalMargin)
                    .right(horizontalMargin)
                    .top(topMargin)
                    .bottom(bottomInset)
                
                UIView.animate(withDuration: 0.3) {
                    self.contentView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}

