//
//  CalendarViewController.swift
//  App
//
//  Created by 윤제 on 8/12/24.
//

import UIKit

import Core
import Data
import Design

import FSCalendar
import ReactorKit
import RxSwift
import RxCocoa

final class CalendarViewController: BaseViewController<CalendarReactor, CalendarView> {
    
    @Navigator var navigator: CalendarNavigatorProtocol
    
    override func setup() {
        setNavigation()
        contentView.calendar.delegate = self
        contentView.calendar.dataSource = self
    }
    
    private func setNavigation() {
        self.navigationController?.navigationBar.tintColor = .recordColor
        self.title = "캘린더"
    }
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        self.reactor?.action.onNext(.viewDidLoad)
        super.viewDidLoad()
    }
    
    override func bind(reactor: CalendarReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
}

// MARK: - Bind
extension CalendarViewController {
    
    private func bindInput(reactor: CalendarReactor) {
        
    }
    
    private func bindOutput(reactor: CalendarReactor) {
        
        contentView.eventTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedEvents }
            .bind(to: contentView.eventTableView.rx.items(cellIdentifier: EventCollectionViewCell.identifier, cellType: EventCollectionViewCell.self)
            ) { _, item, cell in
                
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.restDays }
            .observe(on: MainScheduler.instance)
            .bind { self.contentView.calendar.reloadData() }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedDate }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .map { ($0.0.contentView, $0.1) }
            .bind {
                $0.0.eventDateLabel.text = $0.1.formattedDateString(type: .yearMonthDayWeek)
                $0.0.setNeedsLayout()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedDate }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.contentView.eventRestDayLabel.text = $0.0.checkRestDayName(date: $0.1) }
            .disposed(by: disposeBag)
        
        NotificationCenterService.reloadCalendar.addObserver()
            .withUnretained(self)
            .bind { $0.0.contentView.calendar.today = Date()}
            .disposed(by: disposeBag)
    }
}

// MARK: - FSCalendar
extension CalendarViewController: FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource  {
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        self.reactor?.action.onNext(.didSelectDate(date))
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        return true
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // month 변경
        contentView.monthLabel.text = calendar.currentPage.formatToMonth()
        contentView.yearLabel.text = calendar.currentPage.formatToYear()
        contentView.setNeedsLayout()
    }
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        // 주말 색상 변경
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: date)
        
        if weekDay == 1 || weekDay == 7 {
            return .gray
        }
        
        // 공휴일 색상
        if checkRestDay(date: date) { return .red }
        
        return .black // Weekday color
    }
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleFontFor date: Date
    ) -> UIFont? {
        return DesignFontFamily.GangwonEduAll.bold.font(size: 50)
    }
    
    
    func calendar(
        _ calendar: FSCalendar,
        cellFor date: Date,
        at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        // cell custom
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FScalendarCustomCell.description(), for: date, at: position) as? FScalendarCustomCell else { return FScalendarCustomCell() }
        
        return cell
    }
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        fillSelectionColorFor date: Date
    ) -> UIColor? {
        
        if checkRestDay(date: date) { return .red }
        
        return .black.withAlphaComponent(0.4)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewEventFooterView") as? NewEventFooterView else { return UITableViewHeaderFooterView() }
        
        footerView.newEventButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.navigator.toEventAdd(vc: $0.0) }
            .disposed(by: footerView.disposeBag)
        
        return footerView
    }
}

// MARK: - UserDefine
extension CalendarViewController {
    
    private func checkRestDay(date: Date) -> Bool {
        guard let reactor else { return false }
        
        for restDay in reactor.currentState.restDays {
            let calendar = Calendar.current
            if calendar.isDate(restDay.date, inSameDayAs: date) {
                return true
            }
        }
        
        return false
    }
    
    private func checkRestDayName(date: Date) -> String? {
        guard let reactor else { return nil }
        
        for restDay in reactor.currentState.restDays {
            let calendar = Calendar.current
            if calendar.isDate(restDay.date, inSameDayAs: date) {
                return restDay.dateName
            }
        }
        
        return nil
    }
}
