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
    
    private let seletedDate: Date
    private let pickerMode: UIDatePicker.Mode
    private let minimumDate: Date?
    private let maximumDate: Date?
    
    lazy var datePicker = UIDatePicker().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = self.pickerMode
        $0.minimumDate = self.minimumDate
        $0.maximumDate = self.maximumDate
        $0.date = self.seletedDate
    }
    
    let completeButton = UIButton().then {
        $0.titleLabel?.font = DesignFontFamily.Pretendard.bold.font(size: 16)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = Theme.theme
        $0.setTitle("완료", for: .normal)
    }
    
    var completionHandler: ((Date) -> Void)?
    
    var disposeBag = DisposeBag()
    
    init(
        frame: CGRect,
        seletedDate: Date,
        mode: UIDatePicker.Mode = .dateAndTime,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil
    ) {
        self.seletedDate = seletedDate
        self.pickerMode = mode
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
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
