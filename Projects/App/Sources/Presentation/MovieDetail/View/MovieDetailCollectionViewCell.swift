//
//  MovieDetailCollectionViewCell.swift
//  App
//
//  Created by 윤제 on 7/31/24.
//

import UIKit

import Core

import PinLayout

final class MovieDetailCollectionViewCell: UICollectionViewCell, BaseView {
    
    let imageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
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
        [imageView].forEach { self.addSubview($0) }
        imageView.contentMode = .scaleAspectFill
    }
    
    func setUI() {
        imageView.pin
            .all()
    }
    
    func bind(image: UIImage) {
        self.imageView.image = image
    }
}

