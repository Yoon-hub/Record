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
        let labelPadding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        let containerW: CGFloat
        if bounds.width > 1 {
            containerW = bounds.width
        } else if let w = superview?.bounds.width, w > 0 {
            containerW = max(80, w - 40)
        } else {
            containerW = max(80, UIScreen.main.bounds.width - 40)
        }
        let labelMaxWidth = max(60, containerW - labelPadding.left - labelPadding.right)
        
        messageLabel.preferredMaxLayoutWidth = labelMaxWidth
        messageLabel.pin
            .top(labelPadding.top)
            .left(labelPadding.left)
            .width(labelMaxWidth)
            .sizeToFit(.width)
        
        backgroundView.pin
            .top(0)
            .left(0)
            .width(containerW)
            .height(messageLabel.frame.maxY + labelPadding.bottom)
    }
}
