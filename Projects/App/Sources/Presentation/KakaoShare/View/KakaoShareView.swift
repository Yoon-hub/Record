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
            DesignAsset.kakaoEmo5.image
        ].randomElement()
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
        [kakaoEmoticon].forEach {
            addSubview($0)
        }
    }
    
    func setUI() {
        kakaoEmoticon.pin
            .top(safeAreaInsets.top + 20)
            .hCenter()
            .size(100)
    }
}
