//
//  ColorPickerView.swift
//  App
//
//  Created by 윤제 on 8/22/24.
//

import UIKit

import Core
import Design

import PinLayout
import RxSwift
import RxCocoa

final class ColorPickerView: UIView, BaseView {
    
    let completeButton = UIButton().then {
        $0.titleLabel?.font = DesignFontFamily.Pretendard.bold.font(size: 16)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = DesignAsset.record.color
        $0.setTitle("완료", for: .normal)
    }
    
    var completionHandler: ((Date) -> Void)?
    
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
        self.layer.cornerRadius = 10
        [completeButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setUI() {
        completeButton.pin
            .bottom()
            .marginBottom(16)
            .horizontally(42)
            .height(38)
        
    }

}

