//
//  DiaryViewController.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Core
import Domain

import ReactorKit
import RxSwift
import RxCocoa
import RxKeyboard

final class DiaryViewController: BaseViewController<DiaryReactor, DiaryView> {
    
    @Navigator var navigator: DiaryNavigatorProtocol
    
    private var currentBottomDate: Date?
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollObserver()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 다시 나타날 때 데이터 다시 로드
        reactor?.action.onNext(.viewDidLoad)
    }
    
    // MARK: Set
    override func setup() {
        setNavigation()
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupScrollObserver() {
        // 스크롤 이벤트 감지
        contentView.tableView.rx.contentOffset
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.updateDateFromVisibleBottomCell()
            })
            .disposed(by: disposeBag)
        
        // 스크롤이 끝났을 때도 업데이트
        contentView.tableView.rx.willEndDragging
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.updateDateFromVisibleBottomCell()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateDateFromVisibleBottomCell() {
        guard let reactor = reactor else { return }
        let diaries = reactor.currentState.diaries
        let calendar = Calendar.current
        
        guard !diaries.isEmpty else {
            // 일기가 없으면 현재 날짜로 업데이트
            let currentDate = Date()
            let currentMonth = calendar.component(.month, from: currentDate)
            let currentYear = calendar.component(.year, from: currentDate)
            
            // 현재 표시된 월/년과 비교
            if let previousDate = currentBottomDate {
                let previousMonth = calendar.component(.month, from: previousDate)
                let previousYear = calendar.component(.year, from: previousDate)
                
                if previousMonth == currentMonth && previousYear == currentYear {
                    return // 같은 월/년이면 업데이트하지 않음
                }
            }
            
            currentBottomDate = currentDate
            contentView.updateDateLabels(from: currentDate, animated: true)
            return
        }
        
        // 화면에 보이는 가장 아래 Cell 찾기
        guard let visibleIndexPaths = contentView.tableView.indexPathsForVisibleRows,
              let bottomIndexPath = visibleIndexPaths.max(by: { $0.row < $1.row }) else {
            return
        }
        
        // 가장 아래 Cell의 diary 찾기
        guard bottomIndexPath.row < diaries.count else { return }
        let bottomDiary = diaries[bottomIndexPath.row]
        let bottomDate = bottomDiary.date
        let bottomMonth = calendar.component(.month, from: bottomDate)
        let bottomYear = calendar.component(.year, from: bottomDate)
        
        // 월/년이 변경되었을 때만 업데이트
        if let previousDate = currentBottomDate {
            let previousMonth = calendar.component(.month, from: previousDate)
            let previousYear = calendar.component(.year, from: previousDate)
            
            if previousMonth == bottomMonth && previousYear == bottomYear {
                return // 같은 월/년이면 업데이트하지 않음
            }
        }
        
        currentBottomDate = bottomDate
        contentView.updateDateLabels(from: bottomDate, animated: true)
    }
    
    override func bind(reactor: DiaryReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: DiaryReactor) {
        
        contentView.diaryBackButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)   
            }
            .disposed(by: disposeBag)

        // + 버튼 tap 이벤트
        contentView.plusButton.rx.tap
            .map { Reactor.Action.checkAndNavigateToAdd }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // + 버튼 long press 제스처
        let plusLongPressGesture = UILongPressGestureRecognizer()
        plusLongPressGesture.minimumPressDuration = 0.5
        contentView.plusButton.addGestureRecognizer(plusLongPressGesture)

        plusLongPressGesture.rx.event
            .filter { $0.state == .began }
            .subscribe(onNext: { [weak self] _ in
                
                /// 진동
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()
                
                self?.presentPreviousDayConfirmation()
            })
            .disposed(by: disposeBag)

        // 테이블뷰 아이템 선택
        contentView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self,
                      let reactor = self.reactor,
                      indexPath.row < reactor.currentState.diaries.count else { return }
                
                self.contentView.tableView.deselectRow(at: indexPath, animated: true)
                
                let diary = reactor.currentState.diaries[indexPath.row]
                self.navigator.toDiaryDetail(diary: diary)
            })
            .disposed(by: disposeBag)
        
        // Cell long press 제스처 (삭제)
        let longPressGesture = UILongPressGestureRecognizer()
        contentView.tableView.addGestureRecognizer(longPressGesture)
        
        longPressGesture.rx.event
            .subscribe(onNext: { [weak self] gesture in
                guard gesture.state == .began,
                      let self = self,
                      let reactor = self.reactor else { return }
                
                let location = gesture.location(in: self.contentView.tableView)
                guard let indexPath = self.contentView.tableView.indexPathForRow(at: location),
                      indexPath.row < reactor.currentState.diaries.count else { return }
                
                let diary = reactor.currentState.diaries[indexPath.row]
                self.showDeleteConfirmation(diary: diary)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: DiaryReactor) {
            // 일기 목록 업데이트
        reactor.state
            .map { $0.diaries }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: contentView.tableView.rx.items(
                cellIdentifier: DiaryTableViewCell.identifier,
                cellType: DiaryTableViewCell.self
            )) { [weak self] index, diary, cell in
                guard let self = self else { return }
                
                // 이전 diary와 비교하여 달이 변경되었는지 확인
                let showSeparator: Bool
                if index > 0 {
                    let previousDiary = reactor.currentState.diaries[index - 1]
                    let calendar = Calendar.current
                    let currentMonth = calendar.component(.month, from: diary.date)
                    let currentYear = calendar.component(.year, from: diary.date)
                    let previousMonth = calendar.component(.month, from: previousDiary.date)
                    let previousYear = calendar.component(.year, from: previousDiary.date)
                    
                    showSeparator = (currentMonth != previousMonth) || (currentYear != previousYear)
                } else {
                    showSeparator = false // 첫 번째 cell은 구분선 없음
                }
                
                cell.bind(diary, showMonthSeparator: showSeparator)
            }
            .disposed(by: disposeBag)
        
        // 일기 목록 업데이트 후 맨 아래로 스크롤
        reactor.state
            .map { $0.diaries } 
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] diaries in
                guard let self = self, !diaries.isEmpty else { return }
                
                // 레이아웃 업데이트 후 스크롤 및 하단 정렬 유지
                DispatchQueue.main.async {
                    // 콘텐츠가 테이블 높이보다 작으면 상단 inset을 늘려 하단 정렬
                    let tableView = self.contentView.tableView
                    tableView.layoutIfNeeded()
                    let contentHeight = tableView.contentSize.height
                    let tableHeight = tableView.bounds.height
                    let topInset = max(0, tableHeight - contentHeight)
                    tableView.contentInset.top = topInset

                    let lastIndexPath = IndexPath(row: diaries.count - 1, section: 0)
                    self.contentView.tableView.scrollToRow(
                        at: lastIndexPath,
                        at: .bottom,
                        animated: false
                    )
                }
            })
            .disposed(by: disposeBag)
        
        // 빈 상태 표시/숨김 (tableView가 비어있을 때만 emptyLabel 표시)
        reactor.state
            .map { $0.diaries.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEmpty in
                guard let self = self else { return }
                // tableView가 비어있으면 emptyLabel 표시, 아니면 숨김
                self.contentView.emptyLabel.isHidden = !isEmpty
                self.contentView.tableView.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
        
        // 일기 목록이 변경될 때 초기 날짜 설정 (스크롤 감지로 대체)
        reactor.state
            .map { $0.diaries }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] diaries in
                guard let self = self else { return }
                
                // 초기 로드 시 또는 목록 변경 시 가장 아래 Cell의 날짜로 업데이트
                DispatchQueue.main.async {
                    self.updateDateFromVisibleBottomCell()
                }
            })
            .disposed(by: disposeBag)
        
        // 중복 일기 알림 표시
        reactor.pulse(\.$shouldShowAlert)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(
                    title: "일기 추가 불가",
                    message: message,
                    cancel: false
                ){}
            })
            .disposed(by: disposeBag)
        
        // 일기 추가 화면으로 이동
        reactor.pulse(\.$shouldNavigateToAdd)
            .compactMap { $0 }
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.navigator.toDiaryAdd()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldNavigateToAddWithDate)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] date in
                self?.navigator.toDiaryAdd(selectedDate: date)
            })
            .disposed(by: disposeBag)
        
        // 일기 수정 화면으로 이동
        reactor.pulse(\.$shouldNavigateToEdit)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] diary in
                self?.navigator.toDiaryAdd(editingDiary: diary)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func showDeleteConfirmation(diary: Domain.Diary) {
        let alert = UIAlertController(
            title: "일기 삭제",
            message: "삭제한 일기는 복구할 수 없습니다.\n정말로 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.reactor?.action.onNext(.deleteDiary(diary))
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - Previous Day Handling
extension DiaryViewController {
    
    private func presentPreviousDayConfirmation() {
        let alert = UIAlertController(
            title: "전날 일기 작성",
            message: "메타몽 포인트 200을 사용하여 전날 일기를 작성할 수 있어요. 사용하시겠어요?",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "사용하기", style: .default) { [weak self] _ in
            self?.reactor?.action.onNext(.requestPreviousDayDiary)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true)
    }
}

// MARK: - Test Seed
extension DiaryViewController { 
    
    private static func randomDateWithinLastMonths(months: Int) -> Date {
        let calendar = Calendar.current
        let now = Date()
        let start = calendar.date(byAdding: .month, value: -months, to: now) ?? now
        let interval = now.timeIntervalSince(start)
        let randomOffset = TimeInterval.random(in: 0...interval)
        return start.addingTimeInterval(randomOffset)
    }
}

