//
//  EventCollectionViewCell.swift
//  App
//
//  Created by 윤제 on 8/19/24.
//

import UIKit

import Core
import Design
import Domain

final class EventCollectionViewCell: UITableViewCell, BaseView {
    
    let timeLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
    }
    
    let tagView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = DesignAsset.record.color
    }
    
    let titleLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 13)
    }
    
    let labelStack = UIStackView().then {
        $0.axis = .vertical
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
        
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0))
    }
    
    func configure() {
        contentView.backgroundColor = .systemGray6.withAlphaComponent(0.5)
        self.selectionStyle = .none
        
        contentView.layer.cornerRadius = 8
        
        [timeLabel, tagView, labelStack].forEach {
            self.addSubview($0)
        }
        
        [titleLabel, contentLabel].forEach {
            labelStack.addArrangedSubview($0)
        }
    }
    
    func setUI() {
        timeLabel.pin
            .vCenter(-3)
            .left(16)
            .sizeToFit()
        
        tagView.pin
            .vCenter(-3)
            .left(62)
            .height(40)
            .width(3)
        
        labelStack.pin
            .vCenter(-3)
            .after(of: tagView)
            .marginLeft(12)
            .right()
            .height(40)
    }
    
    func bind(_ event: CalendarEvent) {
        titleLabel.text = event.title
        contentLabel.text = event.content
        timeLabel.text = event.date.formatToTime24Hour()
        tagView.backgroundColor = event.tagColor.toUIColor()
        contentView.backgroundColor = event.tagColor.toUIColor()?.withAlphaComponent(0.08)
    }
}
