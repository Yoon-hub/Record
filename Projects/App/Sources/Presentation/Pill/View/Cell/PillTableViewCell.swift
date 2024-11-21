//
//  PillTableViewCell.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import UIKit

import Core
import Design

import PinLayout

final class PillTableViewCell: UITableViewCell, BaseView {

    let titleLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.light.font(size: 14)
    }
    
    let timeLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.light.font(size: 28)
    }
    
    let underLine = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    let `switch` = UISwitch().then {
        $0.onTintColor = DesignAsset.record.color
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.selectionStyle = .none
        [timeLabel, titleLabel, underLine].forEach { addSubview($0) }
        contentView.addSubview(`switch`)
    }
    
    func setUI() {
        timeLabel.pin
            .vCenter()
            .left(16)
            .sizeToFit()
        
        titleLabel.pin
            .vCenter()
            .left(to: timeLabel.edge.right)
            .marginLeft(8)
            .marginTop(2)
            .sizeToFit()
        
        underLine.pin
            .height(1)
            .horizontally()
            .bottom()
        
        `switch`.pin
            .vCenter()
            .right()
            .marginRight(16)
    }
}

