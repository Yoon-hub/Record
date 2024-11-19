//
//  ToastView.swift
//  Core
//
//  Created by 윤제 on 11/19/24.
//

import UIKit

import PinLayout

final class ToastView: UIView, BaseView {
    
    private lazy var messageLabel = UILabel().then {
        $0.text = message
    }
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.8
        $0.layer.cornerRadius = 10
    }
    
    let message: String
    
    init(frame: CGRect, message: String) {
        self.message = message
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    
    func configure() {
        [backgroundView, messageLabel].forEach { self.addSubview($0) }
    }
    
    func setUI() {
        messageLabel.pin
            .center()
            .sizeToFit()
        
        backgroundView.pin
            .wrapContent(padding: UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4))
            .center(to: messageLabel.anchor.center)
            
    }
}
