//
//  PillAddView.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import UIKit

import Core
import Design

import PinLayout
import FlexLayout
import Lottie

final class PillAddView: UIView, BaseView {
    
    let rootFlexContainer = UIView()
    
    let pillContainerView = UIView()
    let timeContainerView = UIView()
    
    let pillLabel = UILabel().then {
        $0.text = "알약: "
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
    }
    
    let pillTextField = UITextField().then {
        $0.backgroundColor = .systemGray6
    }
    
    let timeLabel = UILabel().then {
        $0.text = "시간: "
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
    }
    
    let timeTextField = UITextField().then {
        $0.backgroundColor = .systemGray6
    }
    
    override init(frame: CGRect) {
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
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.addSubview(rootFlexContainer)
     
        rootFlexContainer
            .flex
            .direction(.column)
            .define
        { flex in
            flex.addItem(pillContainerView).marginHorizontal(20).marginVertical(10)
            flex.addItem(timeContainerView).marginHorizontal(20).marginVertical(10)
        }
        
        pillContainerView
            .flex
            .direction(.row)
            .define
        { flex in
            flex.addItem(pillLabel).marginRight(10)
            flex.addItem(pillTextField).height(40).grow(1)
        }
        
        timeContainerView
            .flex
            .direction(.row)
            .define
        { flex in
            flex.addItem(timeLabel).marginRight(10)
            flex.addItem(timeTextField).height(40).grow(1)
        }
    }
    
    func setUI() {
        rootFlexContainer.pin
            .all()
        
        rootFlexContainer.flex.layout()
    }
}


