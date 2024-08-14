//
//  CalendarViewController.swift
//  App
//
//  Created by 윤제 on 8/12/24.
//

import UIKit

import Core
import Design

import FSCalendar
import ReactorKit
import RxSwift
import RxCocoa

final class CalendarViewController: BaseViewController<CalendarReactor, CalendarView> {
    
    override func setup() {
        setNavigation()
        contentView.calendar.delegate = self
        contentView.calendar.dataSource = self
    }
    
    private func setNavigation() {
        self.navigationController?.navigationBar.tintColor = .recordColor
        self.title = "캘린더"
    }
}

// MARK: - FSCalendar
extension CalendarViewController: FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource  {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // month 변경
        contentView.monthLabel.text = calendar.currentPage.formatToMonth()
        contentView.yearLabel.text = calendar.currentPage.formatToYear()
        contentView.setNeedsLayout()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        // 주말 색상 변경
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: date)
        
        if weekDay == 1 || weekDay == 7 {
            return .gray
        }
        return .black // Weekday color
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleFontFor date: Date) -> UIFont? {
//        return DesignFontFamily.GangwonEduAll.bold.font(size: 50)
//    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // cell custom
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FScalendarCustomCell.description(), for: date, at: position) as? FScalendarCustomCell else { return FScalendarCustomCell() }
        
        
        
        return cell
    }
    

}
