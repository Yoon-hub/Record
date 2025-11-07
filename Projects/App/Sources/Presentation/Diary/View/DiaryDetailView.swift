//
//  DiaryDetailView.swift
//  App
//
//  Created by 윤제 on 1/13/25.
//

import UIKit

import Domain
import Design
import Core

import PinLayout

final class DiaryDetailView: UIView, BaseView {
    
    enum Color {
        static let paperBackgroundColor = UIColor(hex: "#F0F1F2")
        static let textColor = UIColor(hex: "#3E4044")
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let dateLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.bold.font(size: 19)
        $0.textColor = Color.textColor
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.text = "THURSDAY / JANUARY 13 / 2025"
    }
    
    let separatorLine = UIView().then {
        $0.backgroundColor = Color.textColor
    }
    
    let contentLabel = UITextView().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 16)
        $0.textColor = Color.textColor
        $0.backgroundColor = Color.paperBackgroundColor
        $0.textAlignment = .center
        $0.isEditable = false
    }
    
    let diaryBackButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square.dashed"), for: .normal)
        $0.tintColor = DiaryView.Color.textColor
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
        backgroundColor = Color.paperBackgroundColor
        
        addSubview(contentView)
        
        [dateLabel, separatorLine, contentLabel, diaryBackButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUI() {
        let horizontalMargin: CGFloat = 20
        let topMargin: CGFloat = 12
        
        contentView.pin
            .top(safeAreaInsets.top + 8)
            .horizontally()
            .bottom()
        
        dateLabel.pin
            .top(topMargin)
            .horizontally(horizontalMargin)
            .sizeToFit(.width)
        
        separatorLine.pin
            .below(of: dateLabel)
            .marginTop(16)
            .horizontally(72)
            .height(2)
        
        contentLabel.pin
            .below(of: separatorLine)
            .marginTop(32)
            .horizontally(horizontalMargin)
            .bottom()
        
        diaryBackButton.pin
            .right()
            .marginRight(16)
            .width(36)
            .height(24)
            .bottom()
            .marginBottom(24)
        
    }
    
    func updateContent(diary: Domain.Diary) {
        // 날짜 포맷팅: "THURSDAY / JANUARY 13 / 2025"
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // 요일 (THURSDAY)
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: diary.date).uppercased()
        
        // 월 (JANUARY)
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: diary.date).uppercased()
        
        // 일 (13)
        let day = calendar.component(.day, from: diary.date)
        
        // 년도 (2025)
        let year = calendar.component(.year, from: diary.date)
        
        dateLabel.text = "\(weekday) / \(month) \(day) / \(year)"
        
        // 내용 설정
        contentLabel.text = diary.content
        
        // 레이아웃 업데이트
        setNeedsLayout()
    }
}

