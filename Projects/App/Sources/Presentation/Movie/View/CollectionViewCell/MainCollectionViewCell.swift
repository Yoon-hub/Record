//
//  MainCollectionViewCell.swift
//  App
//
//  Created by 윤제 on 7/30/24.
//

import UIKit

import Core
import Domain

import PinLayout

final class MainCollectionViewCell: UICollectionViewCell, BaseView {
    
    let imageView = UIImageView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray6.cgColor
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .gray
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
        [imageView, titleLabel, contentLabel].forEach { self.addSubview($0) }
        imageView.contentMode = .scaleAspectFill
        
    }
    
    func setUI() {
        imageView.pin
            .top()
            .horizontally()
            .aspectRatio(1.0)
            
        
        titleLabel.pin
            .below(of: imageView)
            .marginTop(4)
            .horizontally()
            .height(20)
        
        contentLabel.pin
            .below(of: titleLabel)
            .marginTop(1)
            .horizontally()
            .height(12)
    }
    
    func bind(_ movie: Movie) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let image = movie.image[0].toImage()
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
        titleLabel.text = movie.title
        contentLabel.text = movie.content
    }
}
