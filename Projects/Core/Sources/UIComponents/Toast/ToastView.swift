//
//  ToastView.swift
//  Core
//
//  Created by 윤제 on 11/19/24.
//

import UIKit

import PinLayout

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
        $0.layer.cornerRadius = 10
    }
    
    let message: String
    
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
    }
    
    func setUI() {
        messageLabel.pin
            .sizeToFit() // 텍스트 크기에 맞게 설정
            .center()    // 부모 뷰 기준 중앙
        
        backgroundView.pin
            .wrapContent(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)) // messageLabel을 감싸는 여백
            .center()
    }
}
