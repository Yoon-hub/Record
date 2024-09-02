//
//  EventAddView.swift
//  App
//
//  Created by 윤제 on 8/20/24.
//

import UIKit

import Core
import Design

import PinLayout

final class EventAddView: UIView, BaseView {
    
    let titleTextField = UITextField().then {
        $0.placeholder = "제목"
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 19)
    }

    let titleTagColor = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .systemPink
    }

    let timeIcon = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "watchface.applewatch.case")
    }
    
    let startTimeButton = UIButton().then {
        $0.titleLabel?.font = DesignFontFamily.Pretendard.regular.font(size: 16)
        $0.titleLabel?.numberOfLines = 0
        $0.setTitle("8:00AM", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let endTimeButton = UIButton().then {
        $0.titleLabel?.font = DesignFontFamily.Pretendard.regular.font(size: 16)
        $0.titleLabel?.numberOfLines = 0
        $0.setTitle("8:00AM", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let tildeLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 16)
        $0.text = "~"
    }
    
    let tagIcon = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "lasso")
    }
    
    let tagButton = UIColorWell().then {
        $0.backgroundColor = .systemPink
        $0.selectedColor = DesignAsset.record.color
        $0.layer.cornerRadius = 15
    }
    
    let alarmIcon = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "alarm")
    }
    
    let alarmButton = UIButton().then {
        $0.titleLabel?.font = DesignFontFamily.Pretendard.regular.font(size: 15)
        $0.setTitle("알림 없음", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let memoIcon = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "menucard")
    }
    
    let textView = UITextView().then {
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 14)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
    }
    
    let saveButton = UIButton().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 10, height: 10)
        $0.layer.shadowRadius = 6
        $0.layer.shadowOpacity = 0.1
        $0.layer.cornerRadius = 27
        $0.titleLabel?.font = DesignFontFamily.Pretendard.medium.font(size: 17)
        $0.setImage(UIImage(systemName: "checkmark"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .black
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
        [titleTextField, titleTagColor, timeIcon, startTimeButton, tagIcon, tagButton, alarmIcon, alarmButton, memoIcon, textView, saveButton, tildeLabel, endTimeButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setUI() {
        titleTextField.pin
            .top(self.pin.safeArea.top)
            .marginTop(32)
            .horizontally(32)
            .height(40)
        
        titleTagColor.pin
            .before(of: titleTextField)
            .vCenter(to: titleTextField.edge.vCenter)
            .marginRight(7)
            .height(40)
            .width(3)
        
        timeIcon.pin
            .below(of: titleTextField)
            .marginTop(40)
            .left(20)
            .size(26)
        
        startTimeButton.pin
            .after(of: timeIcon)
            .marginLeft(10)
            .vCenter(to: timeIcon.edge.vCenter)
            .sizeToFit()
        
        tildeLabel.pin
            .after(of: startTimeButton)
            .marginLeft(12)
            .vCenter(to: timeIcon.edge.vCenter)
            .sizeToFit()
        
        endTimeButton.pin
            .after(of: tildeLabel)
            .marginLeft(15)
            .vCenter(to: timeIcon.edge.vCenter)
            .sizeToFit()
        
        tagIcon.pin
            .below(of: timeIcon)
            .marginTop(30)
            .left(20)
            .size(30)
        
        tagButton.pin
            .after(of: tagIcon)
            .marginLeft(10)
            .width(24)
            .vCenter(to: tagIcon.edge.vCenter)
            .height(24)
        
        alarmIcon.pin
            .below(of: tagIcon)
            .marginTop(30)
            .left(20)
            .size(26)
        
        alarmButton.pin
            .after(of: alarmIcon)
            .marginLeft(10)
            .vCenter(to: alarmIcon.edge.vCenter)
            .sizeToFit()
        
        memoIcon.pin
            .below(of: alarmIcon)
            .marginTop(30)
            .left(20)
            .size(26)
        
        textView.pin
            .after(of: memoIcon)
            .top(to: memoIcon.edge.top)
            .marginLeft(10)
            .right(20)
            .height(120)
        
        saveButton.pin
            .bottom(self.pin.safeArea.bottom)
            .marginBottom(30)
            .right(20)
            .size(54)
    }
    
}
