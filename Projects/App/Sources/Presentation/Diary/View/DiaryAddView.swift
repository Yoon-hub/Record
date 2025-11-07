//
//  DiaryAddView.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Design
import Core

import PinLayout

final class DiaryAddView: UIView, BaseView {
    
    enum Color {
        static let paperBackgroundColor = UIColor(hex: "#F0F1F2")
        static let textColor = UIColor(hex: "#3E4044")
    }
    
    let keyboardCompleteButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: nil)
    let keyboardCloseButton = UIBarButtonItem(title: "닫기", style: .plain, target: nil, action: nil)
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = DesignFontFamily.Pretendard.regular.font(size: 16)
        textView.textColor = Color.textColor
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.textAlignment = .center
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupKeyboardToolbar()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupKeyboardToolbar() {
        // 키보드 위에 닫기/완료 버튼이 있는 툴바 추가
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        keyboardCloseButton.setTitleTextAttributes([
            .font: DesignFontFamily.Pretendard.medium.font(size: 16),
            .foregroundColor: Color.textColor
        ], for: .normal)
          
        keyboardCompleteButton.setTitleTextAttributes([
            .font: DesignFontFamily.Pretendard.medium.font(size: 16),
            .foregroundColor: Color.textColor
        ], for: .normal)
        
        toolbar.items = [keyboardCloseButton, flexSpace, keyboardCompleteButton]
        toolbar.tintColor = Color.textColor
        textView.inputAccessoryView = toolbar
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()   
        setUI()
    }
    
    func configure() {
        backgroundColor = Color.paperBackgroundColor
        addSubview(textView)
    }
    
    func setUI() {
        let horizontalMargin: CGFloat = bounds.width * 0.05
        let verticalMargin: CGFloat = bounds.height * 0.05
        
        textView.pin
            .left(horizontalMargin)
            .right(horizontalMargin)
            .top(120)
            .bottom(verticalMargin)
    }
}

 
