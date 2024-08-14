//
//  FScalendarCustomCell.swift
//  App
//
//  Created by 윤제 on 8/13/24.
//

import UIKit

import Core
import Design

import FSCalendar
import PinLayout

final class FScalendarCustomCell: FSCalendarCell, BaseView {
    
    let line = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // PinLayout 적용
        setUI()
    }
    
    func configure() {
        [line].forEach {
            self.addSubview($0)
        }
    }
    
    func setUI() {
        titleLabel.pin
            .top(2)
            .hCenter()
            .sizeToFit()
        
        line.pin
            .top(-4)
            .height(1)
            .horizontally()
    }
}
