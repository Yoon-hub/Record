//
//  ImageListCollectionViewCell.swift
//  App
//
//  Created by 윤제 on 7/18/24.
//

import UIKit

import Core

import PinLayout

final class ImageListCollectionViewCell: UICollectionViewCell, BaseView {
    
    let imageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let xButton = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "x.circle.fill")
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
        [imageView, xButton].forEach { self.addSubview($0) }
        
        imageView.contentMode = .scaleToFill
    }
    
    func setUI() {
        imageView.pin
            .all()
        
        xButton.pin
            .topRight(to: imageView.anchor.topRight)
            .marginTop(-6)
            .marginRight(-8)
            .width(20)
            .height(20)
    }
    
    func bind(image: UIImage) {
        self.imageView.image = image.resize(targetSize: CGSize(width: 71, height: 71))
    }
}
