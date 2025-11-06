//
//  DiaryView.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Design
import Core
import Domain

import PinLayout

final class DiaryView: UIView, BaseView {
    
    enum Color {
        // MARK: - Properties
        static let paperBackgroundColor = UIColor(hex: "#F0F1F2") // 종이 느낌의 배경색
        static let textColor = UIColor(hex: "#3E4044")
    }

    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.backgroundColor = DiaryView.Color.paperBackgroundColor
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        tableView.clipsToBounds = false // Cell 밖으로 나가는 뷰도 보이도록
        return tableView
    }()
    
    let emptyLabel = UILabel().then {
        $0.text = "아직 작성한 일기가 없어요."
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = UIColor(hex: "#3E4044").withAlphaComponent(0.7)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    
    let plusButton = UIButton().then {
        $0.setImage(DesignAsset.plus.image, for: .normal)
    }
    
    let dateBarVerticalBar = UIView().then {
        $0.backgroundColor = DiaryView.Color.textColor
    }
    
    let monthLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = DiaryView.Color.textColor
        $0.textAlignment = .center
        $0.text = "FEBRUARY"
    }
    
    let yearLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = DiaryView.Color.textColor
        $0.textAlignment = .center
        $0.text = "2025"
    }
    
    let bottomBarView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F0F1F2")
    }
    
    let diaryBackButton = UIButton().then {
        $0.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward"), for: .normal)
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
        backgroundColor = DiaryView.Color.paperBackgroundColor
        clipsToBounds = false // Cell 밖으로 나가는 뷰도 보이도록
        
        [tableView, bottomBarView, emptyLabel].forEach {
            self.addSubview($0)
        }
        
        [diaryBackButton, dateBarVerticalBar, plusButton, monthLabel, yearLabel].forEach {
            bottomBarView.addSubview($0)
        }
    }
    
    func setUI() {
        
        bottomBarView.pin
            .bottom()
            .marginBottom(22)
            .horizontally()
            .height(60)
        
        tableView.pin
            .top()
            .horizontally()
            .bottom(to: bottomBarView.edge.top)
        
        emptyLabel.pin
            .center()
            .width(250)
            .sizeToFit(.width)
        
        // 전체 화면 width 기준으로 plusButton을 중앙에 배치
        let spacing: CGFloat = 16
        let plusButtonSize: CGFloat = 32
        
        plusButton.pin
            .vCenter()
//            .right()
//            .marginRight(16)
            .hCenter()
            .size(plusButtonSize)
        
        diaryBackButton.pin
            .vCenter()
            .right()
            .marginRight(16)
            .width(36)
            .height(24)
        
        dateBarVerticalBar.pin
            .vCenter()
            .left()
            .marginLeft(16)
            .height(16)
            .width(7)
        
        // 왼쪽 그룹 배치 (plusButton 왼쪽에 동일한 간격으로)
        monthLabel.pin
            .vCenter()
            .after(of: dateBarVerticalBar)
            .marginLeft(8)
            .sizeToFit()
        
        yearLabel.pin
            .vCenter()
            .after(of: monthLabel)
            .marginLeft(8)
            .sizeToFit()
            
    }
    
    func updateDateLabels(from date: Date, animated: Bool = false) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        // 월 이름을 영어로 변환
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        monthFormatter.locale = Locale(identifier: "en_US_POSIX")
        let monthName = monthFormatter.string(from: date).uppercased()
        let yearString = "\(year)"
        
        // 현재 표시된 월과 년 확인
        let currentMonth = monthLabel.text ?? ""
        let currentYear = yearLabel.text ?? ""
        
        // 월 또는 년이 실제로 변경되는지 확인
        let monthChanged = currentMonth != monthName
        let yearChanged = currentYear != yearString
        let shouldAnimate = animated && (monthChanged || yearChanged)
        
        let updateLabels = {
            self.monthLabel.text = monthName
            self.yearLabel.text = yearString
            
            // 레이아웃 업데이트
            self.monthLabel.sizeToFit()
            self.yearLabel.sizeToFit()
            self.setNeedsLayout()
        }
        
        if shouldAnimate {
            // 페이드 아웃 → 텍스트 변경 → 페이드 인 애니메이션
            UIView.animate(withDuration: 0.2, animations: {
                self.monthLabel.alpha = 0
                self.yearLabel.alpha = 0
            }) { _ in
                updateLabels()
                UIView.animate(withDuration: 0.2) {
                    self.monthLabel.alpha = 1
                    self.yearLabel.alpha = 1
                }
            }
        } else {
            updateLabels()
        }
    }
 
}
