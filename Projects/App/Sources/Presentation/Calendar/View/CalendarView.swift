//
//  CalendarView.swift
//  App
//
//  Created by 윤제 on 8/12/24.
//

import UIKit

import Core
import Design

import FSCalendar
import PinLayout

final class CalendarView: UIView, BaseView {
    
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 0
        calendar.firstWeekday = 2
        
        calendar.appearance.weekdayTextColor = .black
        calendar.placeholderType = .none
//        calendar.appearance.weekdayFont = DesignFontFamily.GangwonEduAll.bold.font(size: 16)
//        calendar.appearance.titleFont = DesignFontFamily.GangwonEduAll.bold.font(size: 16)
        
        calendar.appearance.weekdayFont = DesignFontFamily.Pretendard.medium.font(size: 15)
        calendar.appearance.titleFont = DesignFontFamily.Pretendard.medium.font(size: 15)
        
        
        calendar.appearance.todayColor = .systemGray6
        calendar.appearance.titleTodayColor = .white
        
        calendar.appearance.selectionColor = .black.withAlphaComponent(0.4)
        
        calendar.appearance.borderRadius = 0.3
        calendar.register(FScalendarCustomCell.self, forCellReuseIdentifier: FScalendarCustomCell.description())

        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .gray
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = .gray
        
        
        return calendar
    }()
    
    lazy var monthLabel = UILabel().then {
        $0.text = Date().formatToMonth()
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 54)
        $0.textColor = .black
    }
    
    lazy var yearLabel = UILabel().then {
        $0.text = Date().formatToYear()
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = .systemGray
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
        [monthLabel, calendar, yearLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func setUI() {
        monthLabel.pin
            .top(self.pin.safeArea.top)
            .left(16)
            .height(46)
            .sizeToFit(.height)
        
        yearLabel.pin
            .after(of: monthLabel)
            .bottom(to: monthLabel.edge.bottom)
            .marginBottom(8)
            .sizeToFit()
        
        calendar.pin
            .below(of: monthLabel)
            .marginTop(8)
            .horizontally()
            .height(UIScreen.main.bounds.height / 2.5)
    }
}
