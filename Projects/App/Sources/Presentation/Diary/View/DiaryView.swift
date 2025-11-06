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
        tableView.rowHeight = 75
        return tableView
    }()
    
    let emptyLabel = UILabel().then {
        $0.text = "아직 작성한 일기가 없어요.\n첫 번째 일기를 작성해보세요!"
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 15)
        $0.textColor = .systemGray
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
        
        [tableView, bottomBarView].forEach {
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
 
}
