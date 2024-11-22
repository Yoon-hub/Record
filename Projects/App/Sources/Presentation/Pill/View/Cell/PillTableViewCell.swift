//
//  PillTableViewCell.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import UIKit

import Core
import Domain
import Design

import PinLayout
import RxSwift

final class PillTableViewCell: UITableViewCell, BaseView {

    let titleLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.light.font(size: 14)
    }
    
    let timeLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.light.font(size: 28)
    }
    
    let underLine = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    let `switch` = UISwitch().then {
        $0.onTintColor = DesignAsset.record.color
    }
    
    var disposeBag = DisposeBag()
    
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
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func configure() {
        self.selectionStyle = .none
        [timeLabel, titleLabel, underLine].forEach { addSubview($0) }
        contentView.addSubview(`switch`)
    }
    
    func setUI() {
        timeLabel.pin
            .vCenter()
            .left(16)
            .sizeToFit()
        
        titleLabel.pin
            .vCenter()
            .left(to: timeLabel.edge.right)
            .marginLeft(8)
            .marginTop(2)
            .sizeToFit()
        
        underLine.pin
            .height(1)
            .horizontally()
            .bottom()
        
        `switch`.pin
            .vCenter()
            .right()
            .marginRight(16)
    }
}

extension PillTableViewCell {
    func bind(_ pill: Pill) {
        timeLabel.text = formatTimeString(pill.time)
        titleLabel.text = pill.title
        `switch`.isOn = pill.use
    }
    
    private func formatTimeString(_ time: String) -> String? {
        guard time.count == 4, let hour = Int(time.prefix(2)), let minute = Int(time.suffix(2)) else {
            return nil // 잘못된 형식일 경우 nil 반환
        }
        
        // 시간과 분이 유효한지 확인 (00~23, 00~59)
        guard (0...23).contains(hour), (0...59).contains(minute) else {
            return nil
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
}

