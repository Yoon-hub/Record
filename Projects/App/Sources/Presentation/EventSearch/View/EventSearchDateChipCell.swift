//
//  EventSearchDateChipCell.swift
//  App
//

import UIKit

import Core
import Design

import PinLayout

final class EventSearchDateChipCell: UICollectionViewCell {
    
    let titleLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 13)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.pin.all().marginHorizontal(12).marginVertical(6)
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        if isSelected {
            contentView.backgroundColor = .recordColor.withAlphaComponent(0.18)
            titleLabel.textColor = .recordColor
        } else {
            contentView.backgroundColor = .systemGray6
            titleLabel.textColor = .label
        }
    }
}
