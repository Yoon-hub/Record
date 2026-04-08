//
//  EventSearchViewController.swift
//  App
//

import UIKit

import Core
import Design
import Domain

import ReactorKit
import RxSwift
import RxCocoa

final class EventSearchViewController: BaseViewController<EventSearchReactor, EventSearchView> {
    
    @Navigator var navigator: CalendarNavigatorProtocol
    
    private var eventDaySections: [EventDaySection] = []
    private var selectedDateTabIndex: Int = 0
    
    override func setup() {
        title = "일정 검색"
        navigationController?.navigationBar.tintColor = .recordColor
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.dateTabCollectionView.dataSource = self
        contentView.dateTabCollectionView.delegate = self
    }
    
    override func bind(reactor: EventSearchReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }
}

private extension EventSearchViewController {
    
    func bindInput(reactor: EventSearchReactor) {
        contentView.searchTextField.rx.text.orEmpty
            .observe(on: MainScheduler.instance)
            .map { EventSearchReactor.Action.searchTextChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: EventSearchReactor) {
        reactor.state.map { $0.eventDaySections }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { vc, sections in
                vc.eventDaySections = sections
                vc.selectedDateTabIndex = 0
                let hasSections = !sections.isEmpty
                vc.contentView.setDateTabsVisible(hasSections)
                vc.contentView.setNeedsLayout()
                vc.contentView.layoutIfNeeded()
                vc.contentView.tableView.reloadData()
                vc.contentView.dateTabCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    func openEventFix(event: CalendarEvent, occurrenceDay: Date, reactor: EventSearchReactor) {
        let day = Calendar.current.startOfDay(for: occurrenceDay)
        navigator.toEventFix(
            vc: self,
            seletedDate: day,
            currentEvent: event,
            reloadTableView: {
                NotificationCenterService.reloadCalendar.post()
                reactor.action.onNext(.reloadEvents)
            }
        )
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EventSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        eventDaySections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventDaySections[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: EventSearchEventCell.identifier,
            for: indexPath
        ) as! EventSearchEventCell
        let section = eventDaySections[indexPath.section]
        let event = section.events[indexPath.row]
        cell.configure(with: event, occurrenceDay: section.day)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        eventDaySections[section].day.formattedDateString(type: .yearMonthDayWeek)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let reactor else { return }
        let section = eventDaySections[indexPath.section]
        let event = section.events[indexPath.row]
        openEventFix(event: event, occurrenceDay: section.day, reactor: reactor)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension EventSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        eventDaySections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EventSearchDateChipCell.identifier,
            for: indexPath
        ) as! EventSearchDateChipCell
        let day = eventDaySections[indexPath.item].day
        let title = day.formattedDateString(type: .simpleMonthDay)
        cell.configure(title: title, isSelected: indexPath.item == selectedDateTabIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = eventDaySections[indexPath.item].day.formattedDateString(type: .simpleMonthDay)
        let font = DesignFontFamily.Pretendard.medium.font(size: 13)
        let width = (title as NSString).size(withAttributes: [.font: font]).width + 24
        return CGSize(width: max(52, ceil(width)), height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDateTabIndex = indexPath.item
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        guard indexPath.item < eventDaySections.count,
              !eventDaySections[indexPath.item].events.isEmpty
        else { return }
        let tableIndexPath = IndexPath(row: 0, section: indexPath.item)
        contentView.tableView.scrollToRow(at: tableIndexPath, at: .top, animated: true)
    }
}
