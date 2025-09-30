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
        
        [imageView, speechLabel, pointLabel, shoppingButton].forEach {
            self.addSubview($0)
        }
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {

    }

    func setUI() {
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
            .width(200)  // 충분한 너비 확보
            .sizeToFit(.width)
        
    }
}
