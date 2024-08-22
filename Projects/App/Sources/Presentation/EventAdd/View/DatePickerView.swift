//
//  DatePickeriew.swift
//  App
//
//  Created by 윤제 on 8/21/24.
//

import UIKit

import Core
import Design

import PinLayout
import RxSwift
import RxCocoa

final class DatePickerView: UIView, BaseView {
    
    let seletedDate: Date
    
    lazy var datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .time
        $0.date = self.seletedDate
    }
    
    let completeButton = UIButton().then {
        $0.titleLabel?.font = DesignFontFamily.Pretendard.bold.font(size: 16)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = DesignAsset.record.color
        $0.setTitle("완료", for: .normal)
    }
    
    var completionHandler: ((Date) -> Void)?
    
    var disposeBag = DisposeBag()
    
    init(frame: CGRect, seletedDate: Date) {
        self.seletedDate = seletedDate
        super.init(frame: frame)
        
        configure()
        bind()
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
        self.layer.cornerRadius = 10
        [datePicker, completeButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setUI() {
        completeButton.pin
            .bottom()
            .marginBottom(16)
            .horizontally(42)
            .height(38)
        
        datePicker.pin
            .top()
            .horizontally()
            .above(of: completeButton)
    }
    
    private func bind() {
        completeButton.rx.tap
            .withUnretained(self)
            .bind { $0.0.completionHandler?($0.0.datePicker.date) }
            .disposed(by: disposeBag)
    }
}
