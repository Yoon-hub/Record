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
    
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let containerView = UIView()
    
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 0
        calendar.firstWeekday = 2
        
        calendar.appearance.weekdayTextColor = .black
        calendar.placeholderType = .none
        
        calendar.appearance.weekdayFont = DesignFontFamily.Pretendard.medium.font(size: 15)
        calendar.appearance.titleFont = DesignFontFamily.Pretendard.medium.font(size: 15)
        
        
        calendar.appearance.todayColor = .systemGray6
        calendar.appearance.titleTodayColor = .white
        
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
    
    let eventView = UIView()
    
    let eventDateLabel = UILabel().then {
        $0.text = Date().formattedDateString(type: .yearMonthDayWeek)
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 19)
        $0.textColor = .black
    }
    
    let eventRestDayLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = .red
    }
    
    var eventTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.register(
            EventCollectionViewCell.self,
            forCellReuseIdentifier: EventCollectionViewCell.identifier
        )
        
        tableView.register(
            NewEventFooterView.self,
            forHeaderFooterViewReuseIdentifier: NewEventFooterView.identifier
        )
        
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
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
        
        self.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [monthLabel, calendar, yearLabel, eventView].forEach {
            containerView.addSubview($0)
        }
        
        [eventDateLabel, eventTableView, eventRestDayLabel].forEach {
            eventView.addSubview($0)
        }
    }
    
    func setUI() {
        scrollView.pin
            .all(self.pin.safeArea)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        
        containerView.pin
            .top()
            .horizontally()
            .bottom()
            .height(800)
        
        monthLabel.pin
            .top()
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
        
        eventView.pin
            .below(of: calendar)
            .marginTop(16)
            .horizontally()
            .bottom()
        
        eventDateLabel.pin
            .top()
            .left(16)
            .sizeToFit()
        
        eventTableView.pin
            .below(of: eventDateLabel)
            .marginTop(8)
            .horizontally(8)
            .bottom()
        
        eventRestDayLabel.pin
            .above(of: eventTableView)
            .marginBottom(8)
            .right(16)
            .sizeToFit()
    }
}
