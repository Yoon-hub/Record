//
//  ToastView.swift
//  Core
//
//  Created by 윤제 on 11/19/24.
//

import UIKit

import PinLayout
import RxSwift
import RxCocoa

final class ToastView: UIView, BaseView {
    
    private let messageLabel = UILabel().then {
        $0.numberOfLines = 0 // 멀티라인 지원
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
    }
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.8
        $0.layer.cornerRadius = 12
    }
    
    var onTap: (() -> Void)?
    
    let message: String
    
    private let disposeBag = DisposeBag()
    
    init(frame: CGRect, message: String) {
        self.message = message
        super.init(frame: frame)
        configure()
        self.messageLabel.text = message // 초기화 시 메시지 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    func configure() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(messageLabel)
        
        // 터치 제스처 추가
        let tapGesture = UITapGestureRecognizer()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .withUnretained(self)
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .bind {
                $0.0.onTap?()
            }
            .disposed(by: disposeBag)
    }
    
    func setUI() {
        messageLabel.pin
            .sizeToFit()
            .center()
        
        backgroundView.pin
            .wrapContent(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)) // messageLabel을 감싸는 여백
            .center()
    }
}
