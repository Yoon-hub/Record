//
//  DairyCell.swift
//  App
//
//  Created by 윤제 on 11/5/25.
//

import UIKit

import Domain
import Design

import PinLayout

final class DiaryTableViewCell: UITableViewCell {
    
    enum Color {
        // MARK: - Properties
        static let paperBackgroundColor = UIColor(hex: "#F0F1F2") // 종이 느낌의 배경색
        static let textColor = UIColor(hex: "#3E4044")
    }
 
    let weekBox = UIView().then {
        $0.backgroundColor = .systemGray5
        $0.layer.borderColor = Color.textColor.cgColor
        $0.layer.borderWidth = 1
    }
    
    let dateBox = UIView().then {
        $0.backgroundColor = Color.paperBackgroundColor
        $0.layer.borderColor = Color.textColor.cgColor
        $0.layer.borderWidth = 1
    }
    
    let labelBox = UIView().then {
        $0.backgroundColor = Color.paperBackgroundColor
        $0.layer.borderColor = Color.textColor.cgColor
        $0.layer.borderWidth = 1
    }
    
    let dateLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 17)
        $0.textColor = Color.textColor
        $0.textAlignment = .center
        $0.text = "12"
    }
    
    let weekLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 13)
        $0.textColor = Color.textColor
        $0.textAlignment = .center
        $0.text = "MON"
    }
    
    let contentLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 13)
        $0.textColor = Color.textColor
        $0.numberOfLines = 2
        $0.text = "사랑해 재은아"
    }
    
    let monthSeparatorCircle = UIView().then {
        $0.backgroundColor = Color.textColor
        $0.layer.cornerRadius = 3
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
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // 기본 높이 75 + 달 변경 시 추가 공백 20
        let baseHeight: CGFloat = 75
        let totalHeight = baseHeight + topMargin
        return CGSize(width: size.width, height: totalHeight)
    }
    

    func configure() {
        selectionStyle = .none  
        backgroundColor = Color.paperBackgroundColor
        clipsToBounds = false // Cell 밖으로 나가는 뷰도 보이도록
        contentView.clipsToBounds = false
        
        [weekBox, dateBox, labelBox, monthSeparatorCircle].forEach { contentView.addSubview($0) }
        
        weekBox.addSubview(weekLabel)
        dateBox.addSubview(dateLabel)
        labelBox.addSubview(contentLabel)
    }
    
    private var topMargin: CGFloat = 0
    
    func setUI() {
        // 달이 바뀔 때 추가되는 top margin
        let topOffset = topMargin
        
        weekBox.pin
            .top(topOffset)
            .left(12)
            .width(42)
            .height(22)
        
        dateBox.pin
            .top(to: weekBox.edge.bottom)
            .marginTop(-1)
            .left(12)
            .bottom()
            .marginBottom(14)
            .width(42)

        labelBox.pin
            .top(topOffset)
            .left(to: dateBox.edge.right)
            .marginLeft(-1)
            .right()
            .marginRight(12)
            .bottom()
            .marginBottom(14)
        
        weekLabel.pin
            .center()
            .sizeToFit()
        
        dateLabel.pin
            .center()
            .sizeToFit()
        
        contentLabel.pin
            .horizontally(8)
            .vCenter()
            .sizeToFit(.width)
        
        // 달이 바뀔 때 공백 중간에 동그라미 배치
        // contentView의 top에서 topMargin/2 위치에 배치
        // 이전 Cell의 bottom과 현재 Cell의 top 사이 공백(20pt)의 정중앙(10pt)에 위치
        if topMargin > 0 {
            monthSeparatorCircle.pin
                .top(6)
                .hCenter()
                .size(6)
        } else {
            monthSeparatorCircle.pin
                .top(0)
                .hCenter()
                .size(6)
        }
    }
    
    func bind(_ diary: Domain.Diary, showMonthSeparator: Bool = false) {
        // 달이 바뀔 때 top margin 추가 (공백 생성)
        topMargin = showMonthSeparator ? 30 : 0
        
        // 요일을 "MON", "TUE" 형식으로 표시
        let weekFormatter = DateFormatter()
        weekFormatter.dateFormat = "EEE"
        weekFormatter.locale = Locale(identifier: "en_US_POSIX")
        let weekString = weekFormatter.string(from: diary.date).uppercased()
        
        // "MON" 같은 형식으로 변환 (3글자만)
        let weekShort = String(weekString.prefix(3))
        weekLabel.text = weekShort
        
        // 일(day)을 숫자로 표시
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        dateLabel.text = dayFormatter.string(from: diary.date)
        
        // 주말이면 빨간색으로 표시
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: diary.date)
        // 1 = 일요일, 7 = 토요일
        let isWeekend = weekday == 1 || weekday == 7
        
        if isWeekend {
            //weekLabel.textColor = .systemRed
            dateLabel.textColor = UIColor(hex: "#D5586E")
        } else {
            //weekLabel.textColor = Color.textColor
            dateLabel.textColor = Color.textColor
        }
        
        contentLabel.text = diary.content
        
        // 달 변경 구분선 표시
        monthSeparatorCircle.isHidden = !showMonthSeparator
        
        // 레이아웃 업데이트
        setNeedsLayout()
        self.layoutIfNeeded()
    }
}
        
