//
//  KakaoShareView.swift
//  App
//
//  Created by 윤제 on 1/15/25.
//

import UIKit

import Core
import Design

import PinLayout

final class KakaoShareView: UIView, BaseView {
    
    let kakaoEmoticon = UIImageView().then {
        $0.image = [
            DesignAsset.kakaoEmo1.image,
            DesignAsset.kakaoEmo2.image,
            DesignAsset.kakaoEmo3.image,
            DesignAsset.kakaoEmo4.image,
        ].randomElement()
    }
        
        let kakaoShareLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 18)
        $0.text = "공유받은 이벤트가 있어요!"
    }
    
    let titleLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 16)
        $0.textColor = .black

    }
    
    let dateLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = .systemGray
    }
    
    let alarmLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = .systemGray
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 15)
        $0.textColor = .black
    }
    
    let verticalVar = UIView().then {
        $0.layer.cornerRadius = 2
    }
    
    var addButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("이벤트 추가", for: .normal)
        $0.titleLabel?.font = DesignFontFamily.Pretendard.bold.font(size: 16)
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
        [kakaoEmoticon,
         kakaoShareLabel,
         titleLabel,
         alarmLabel,
         contentLabel,
         dateLabel,
         verticalVar,
         addButton
        ].forEach {
            addSubview($0)
        }
    }
    
    func setUI() {
        
        kakaoEmoticon.pin
            .top(safeAreaInsets.top + 26)
            .hCenter()
            .size(70)
        
        kakaoShareLabel.pin
            .top(safeAreaInsets.top + 12)
            .hCenter()
            .sizeToFit()
        
        titleLabel.pin
            .below(of: kakaoEmoticon)
            .marginTop(30)
            .hCenter()
            .sizeToFit()
        
        dateLabel.pin
            .below(of: titleLabel)
            .marginTop(10)
            .hCenter()
            .sizeToFit()
        
        alarmLabel.pin
            .below(of: dateLabel)
            .marginTop(10)
            .hCenter()
            .sizeToFit()
        
        contentLabel.pin
            .below(of: alarmLabel)
            .marginTop(22)
            .hCenter()
            .sizeToFit()
        
        verticalVar.pin
            .top(to: titleLabel.edge.top)
            .left(16)
            .bottom(to: contentLabel.edge.bottom)
            .width(3)
        
        addButton.pin
            .horizontally()
            .bottom()
            .height(54)
    }
}
