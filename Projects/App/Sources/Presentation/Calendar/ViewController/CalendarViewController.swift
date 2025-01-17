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

import FloatingBottomSheet
import FSCalendar
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture

final class CalendarViewController: BaseViewController<CalendarReactor, CalendarView> {
    
    @Navigator var navigator: CalendarNavigatorProtocol
    
    override func setup() {
        setNavigation()
        contentView.calendar.delegate = self
        contentView.calendar.dataSource = self
    }
    
    // MARK: - Navigation
    private func setNavigation() {
        self.navigationController?.navigationBar.tintColor = .recordColor
        self.title = "캘린더"
        makeNaviagtionItem()
    }
    private func makeNaviagtionItem() {
        let rightBarSettingButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(gearTap))
        let rightBarPillButtonItem = UIBarButtonItem(image: UIImage(systemName: "pill"), style: .plain, target: self, action: #selector(pillTap))

        rightBarPillButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)

        self.navigationItem.rightBarButtonItems = [rightBarSettingButtonItem, rightBarPillButtonItem]
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
    
    /// 설정 화면 Transtion
    @objc private func gearTap() {
        navigator.toSetting()
    }
    
    /// 알략 Bottom Sheet
    @objc private func pillTap() {
        navigator.toPill(self)
    }
}

// MARK: - Bind
extension CalendarViewController {
    
    private func bindInput(reactor: CalendarReactor) {
        contentView.eventTableView.rx.itemSelected
            .withUnretained(self)
            .bind {
                $0.0.navigator.toEventFix(vc: $0.0, seletedDate: $0.0.reactor!.currentState.selectedDate, currentEvent: $0.0.reactor!.currentState.selectedEvents[$0.1.row]) {
                    self.reactor?.action.onNext(.reloadEvents)
                }
            }
            .disposed(by: disposeBag)
    
        contentView.todayButton.rx.tap
            .withUnretained(self)
            .bind { $0.0.contentView.calendar.setCurrentPage(Date(), animated: true) }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarReactor) {
        
        contentView.eventTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedEvents }
            .bind(to: contentView.eventTableView.rx.items(cellIdentifier: EventCollectionViewCell.identifier, cellType: EventCollectionViewCell.self)
            ) { _, item, cell in
                cell.bind(item)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.events }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.contentView.calendar.reloadData() }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.restDays }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.contentView.calendar.reloadData() }
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
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { _ in
                reactor.action.onNext(.viewDidLoad)
            }
            .disposed(by: disposeBag)
        
        NotificationCenterService.reloadCalendar.addObserver()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.contentView.calendar.today = Date() }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isToast)
            .observe(on: MainScheduler.instance)
            .bind { Toast.show(
                message: $0,
                duration: .short,
                position: .top
            ) {
                reactor.action.onNext(.undoDeleteEvent)
            }}
            .disposed(by: disposeBag)

        reactor.pulse(\.$calendarUIUpdate)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.contentView.calendar.firstWeekday = UInt(UserDefaultsWrapper.firstWeekday) ?? 2
                if UserDefaultsWrapper.firstWeekday == SettingReactor.SettingList.FirstWeekday.sunday {
                    $0.0.contentView.calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .gray
                    $0.0.contentView.calendar.calendarWeekdayView.weekdayLabels[0].textColor = .gray
                } else {
                    $0.0.contentView.calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .gray
                    $0.0.contentView.calendar.calendarWeekdayView.weekdayLabels[5].textColor = .gray
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$kakaoEvent)
            .observe(on: MainScheduler.instance)
            .compactMap {$0}
            .withUnretained(self)
            .bind {
                $0.0.navigator.toKakaoShare($0.0)
            }
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
        
        let currentPage = calendar.currentPage
        let calendarInstance = Calendar.current
        
        // Get the first day of the current page (month)
        var components = calendarInstance.dateComponents([.year, .month], from: currentPage)
        components.day = 1
        
        if let firstDayOfMonth = calendarInstance.date(from: components) {
            let today = Date()
            var calendarCurrent = Calendar.current

            // TimeZone을 한국 표준시(KST)로 설정
            calendarCurrent.timeZone = TimeZone(identifier: "Asia/Seoul")!

            // 현재 날짜에서 연, 월, 일 정보를 가져옴
            var components = calendarCurrent.dateComponents([.year, .month, .day], from: today)

            // 시간을 00:00:00으로 설정
            components.hour = 0
            components.minute = 0
            components.second = 0

            // 새로운 날짜 생성
            guard let updatedToday = calendarCurrent.date(from: components) else {return}
            
            // Check if the current month is the same as today's month and year
            let isCurrentMonth = calendarInstance.isDate(today, equalTo: firstDayOfMonth, toGranularity: .month) &&
            calendarInstance.isDate(today, equalTo: firstDayOfMonth, toGranularity: .year)
            
            let dateToSelect = isCurrentMonth ? updatedToday : firstDayOfMonth
            calendar.select(dateToSelect)
            
            delay(0.1) {
                self.reactor?.action.onNext(.didSelectDate(dateToSelect))
            }
        }
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
        
        guard let reactor else { return FScalendarCustomCell() }
        
        let beforeDateEvents = reactor.filterEventsByDate(events: reactor.currentState.events, date: date.addingTimeInterval(-86400)).sorted { $0.startDate < $1.startDate }
        let events = reactor.filterEventsByDate(events: reactor.currentState.events, date: date).sorted { $0.startDate < $1.startDate }
        let afterDateEvents = reactor.filterEventsByDate(events: reactor.currentState.events, date: date.addingTimeInterval(86400)).sorted { $0.startDate < $1.startDate }
        
        
        let isSelected = date == reactor.currentState.selectedDate
        
        cell.bind(events, beforeDate: beforeDateEvents, afterDate: afterDateEvents, isSelected: isSelected)
        return cell
    }
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        fillSelectionColorFor date: Date
    ) -> UIColor? {
        
        if checkRestDay(date: date) { return .red.withAlphaComponent(0.6) }
        
        return .black.withAlphaComponent(0.3)
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
            .bind { $0.0.navigator.toEventAdd(vc: $0.0, seletedDate: $0.0.reactor!.currentState.selectedDate) { self.reactor?.action.onNext(.reloadEvents) } }
            .disposed(by: footerView.disposeBag)
        
        return footerView
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        guard let reactor else {return UISwipeActionsConfiguration()}
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.reactor?.action.onNext(.didDeleteEvent(indexPath))
            completionHandler(true)
        }
        
        let id = reactor.currentState.selectedEvents[indexPath.row].id
        LocalPushService.shared.removeNotification(identifiers: [id])
        
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.red)
        deleteAction.backgroundColor = .white
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
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
