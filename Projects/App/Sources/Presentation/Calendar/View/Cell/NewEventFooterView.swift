//
//  newEventFooterView.swift
//  App
//
//  Created by 윤제 on 8/19/24.
//

import UIKit

import Core
import Design

import PinLayout
import RxSwift

final class NewEventFooterView: UITableViewHeaderFooterView, BaseView {
    
    let plusImage = UIImageView(image: UIImage(systemName: "plus")!).then {
        $0.tintColor = .black
    }
    
    let newEventLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
        $0.text = "새로운 이벤트"
    }
    
    let newEventButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        // 재사용될 때 이전 구독을 취소
        disposeBag = DisposeBag()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        self.contentView.backgroundColor = .systemGray6.withAlphaComponent(0.5)
        self.contentView.layer.cornerRadius = 8
        
        [plusImage, newEventLabel].forEach {
            self.addSubview($0)
        }
        
        self.contentView.addSubview(newEventButton)
    }
    
    func setUI() {
        plusImage.pin
            .left(12)
            .vCenter()
            .size(12)
        
        newEventLabel.pin
            .after(of: plusImage)
            .marginLeft(4)
            .vCenter()
            .sizeToFit()
        
        newEventButton.pin
            .all()
    }
    
}
