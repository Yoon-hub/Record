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
        $0.numberOfLines = 0
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
    }
    
    let tagView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = Theme.theme
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
    
    let diaryLabel = UILabel().then {
        $0.text = "일기 작성"
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 10)
        $0.textColor = UIColor(hex: "#3E4044").withAlphaComponent(0.6)
        $0.isHidden = true
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
        
        [timeLabel, tagView, labelStack, diaryLabel].forEach {
            self.addSubview($0)
        }
        
        [titleLabel, contentLabel].forEach {
            labelStack.addArrangedSubview($0)
        }
    }
    
    func setUI() {
        timeLabel.pin
            .before(of: tagView)
            .left(16)
            .vertically()
            .marginBottom(6)
        
        tagView.pin
            .vCenter(-3)
            .left(72)
            .height(42)
            .width(3)
        
        labelStack.pin
            .vCenter(-3)
            .after(of: tagView)
            .marginLeft(12)
            .right()
            .height(40)
        
        diaryLabel.pin
            .after(of: titleLabel)
            .marginLeft(8)
            .vCenter(to: titleLabel.edge.vCenter)
            .sizeToFit()
    }
    
    func bind(_ event: CalendarEvent, hasDiary: Bool = false) {
        titleLabel.text = event.title
        contentLabel.text = event.content
        tagView.backgroundColor = event.tagColor.toUIColor()
        contentView.backgroundColor = event.tagColor.toUIColor()?.withAlphaComponent(0.12)
        diaryLabel.isHidden = !hasDiary
        
        makeDateString(event)
    }
    
    private func makeDateString(_ event: CalendarEvent) {
        if event.startDate == event.endDate { // 끝과 시작이 같을 경우
            timeLabel.font = DesignFontFamily.Pretendard.medium.font(size: 15)
            timeLabel.text = event.startDate.formatToTime24Hour()
        } else if Calendar.current.isDate(event.startDate, inSameDayAs: event.endDate) { // 같은 날짜일 경우
            
            let startDateComponent = Calendar.current.dateComponents([.hour, .minute], from: event.startDate)
            let endDateComponent = Calendar.current.dateComponents([.hour, .minute], from: event.endDate)
            
            if startDateComponent.hour == 0 && startDateComponent.minute == 00 && endDateComponent.hour == 23 && endDateComponent.minute == 59 { // 하루 종일 일 경우
                timeLabel.text = "AllDay"
                timeLabel.font = DesignFontFamily.Pretendard.medium.font(size: 14)
                return
            }
            
            let startTime = event.startDate.formatToTime24Hour()
            let endTime = event.endDate.formatToTime24Hour()

            let startFont = DesignFontFamily.Pretendard.medium.font(size: 15)
            let endFont = DesignFontFamily.Pretendard.medium.font(size: 13)

            let attributedText = NSMutableAttributedString(
                string: startTime,
                attributes: [NSAttributedString.Key.font: startFont]
            )

            attributedText.append(NSAttributedString(
                string: "\n~\(endTime)",
                attributes: [NSAttributedString.Key.font: endFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
            ))

            timeLabel.attributedText = attributedText
        } else { // 다른 날짜일 경우
            
            let startDate = event.startDate.formattedDateString(type: .simpleMonthDay)
            let startTime = event.startDate.formatToTime24Hour()
            
            let endDate = event.endDate.formattedDateString(type: .simpleMonthDay)
            let endTime = event.endDate.formatToTime24Hour()

            
            let dateFont = DesignFontFamily.Pretendard.medium.font(size: 9)
            let timeFont = DesignFontFamily.Pretendard.medium.font(size: 13)

            
            let attributedText = NSMutableAttributedString(
                string: startDate,
                attributes: [NSAttributedString.Key.font: dateFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
            
            attributedText.append(NSAttributedString(
                string: "\n\(startTime)",
                attributes: [NSAttributedString.Key.font: timeFont, NSAttributedString.Key.foregroundColor: UIColor.black]
            ))
            
            attributedText.append(NSAttributedString(
                string: "\n\(endDate)",
                attributes: [NSAttributedString.Key.font: dateFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
            ))
            
            attributedText.append(NSAttributedString(
                string: "\n~\(endTime)",
                attributes: [NSAttributedString.Key.font: timeFont, NSAttributedString.Key.foregroundColor: UIColor.black]
            ))

            timeLabel.attributedText = attributedText
        }
        
    }
}
