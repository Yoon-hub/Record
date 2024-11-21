//
//  SettingTableViewCell.swift
//  App
//
//  Created by 윤제 on 11/20/24.
//

import UIKit

import Core
import Design

import PinLayout

final class SettingTableViewCell: UITableViewCell, BaseView {

    let titleLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.light.font(size: 17)
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 14)
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
        [titleLabel, contentLabel].forEach { addSubview($0) }
    }
    
    func setUI() {
        titleLabel.pin
            .vCenter()
            .left(32)
            .sizeToFit()
        
        contentLabel.pin
            .vCenter()
            .right(22)
            .sizeToFit()
    }
}
