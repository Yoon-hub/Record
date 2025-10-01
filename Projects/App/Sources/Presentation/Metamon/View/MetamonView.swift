//
//  MetamonView.swift
//  App
//
//  Created by 윤제 on 9/29/25.
//

import UIKit

import Core
import Design

import PinLayout
import RxSwift
import RxCocoa

final class MetamonView: UIView, BaseView {
    
    // 메타몽 컨테이너 뷰 (드래그 가능)
    let metamonContainer = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    let imageView = UIImageView().then {
        $0.image = DesignAsset.metamon.image
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
    }
    
    let speechLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.alpha = 0
    }
    
    let pointLabel = UILabel().then {
        $0.font = DesignFontFamily.PressStart2P.regular.font(size: 12)
        $0.text = "POINT: 1,000"
    }
    
    let shoppingButton = UIButton().then {
        $0.setImage(DesignAsset.shopping.image, for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    let feedButton = UIButton().then {
        $0.setImage(DesignAsset.meal.image, for: .normal)
    }
    
    let tapGesture = UITapGestureRecognizer()
    private let disposeBag = DisposeBag()
    
    // 말풍선 타이머 관리
    var speechTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        speechTimer?.invalidate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    func configure() {
        self.backgroundColor = .white
        
        [metamonContainer, speechLabel, pointLabel, shoppingButton, feedButton].forEach {
            self.addSubview($0)
        }
        
        metamonContainer.addSubview(imageView)
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {

    }

    func setUI() {
        // 메타몽 컨테이너 초기 위치 (중앙) - 크기 증가
        metamonContainer.pin
            .size(350)
            .center()
        
        // 메타몽 이미지는 컨테이너를 가득 채움
        imageView.pin
            .all()
        
        shoppingButton.pin
            .size(60)
            .left(20)
            .bottom(28)
        
        pointLabel.pin
            .after(of: shoppingButton)
            .marginLeft(8)
            .vCenter(to: shoppingButton.edge.vCenter)
            .width(200)
            .sizeToFit(.width)
        
        // 밥 주기 버튼 (shoppingButton 옆에)
        feedButton.pin
            .size(63)
            .right(20)
            .vCenter(to: shoppingButton.edge.vCenter)
        
    }
}
