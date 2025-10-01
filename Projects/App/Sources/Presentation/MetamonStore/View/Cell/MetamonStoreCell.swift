//
//  MetamonStoreCell.swift
//  App
//
//  Created by 윤제 on 10/1/25.
//

import UIKit

import Core
import Design
import Domain

import PinLayout

final class MetamonStoreCell: UICollectionViewCell, BaseView {
    
    let imageView = UIImageView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.image = DesignAsset.thumnailImage.image
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .gray
        $0.text = "보유중"
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
        [imageView, contentLabel].forEach { self.addSubview($0) }
        imageView.contentMode = .scaleAspectFill
        
    }
    
    func setUI() {
        imageView.pin
            .top()
            .horizontally()
            .aspectRatio(1.0)
        
        // contentLabel을 imageView 내부의 오른쪽 하단에 배치
        contentLabel.pin
            .bottom(to: imageView.edge.bottom)
            .right(to: imageView.edge.right)
            .marginBottom(8)
            .marginRight(8)
            .sizeToFit()
    }
    
    func bind(
        _ metamonItem: MetamonItem,
        selectedItem: Bool,
        owenItem: Bool
    ) {
        imageView.image = metamonItem.itemImage
        
        if selectedItem {
            imageView.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.systemGray5.cgColor
        }
        
        if owenItem {
            contentLabel.text = "보유중"
        } else {
            contentLabel.text = "P \(metamonItem.price.addComma())"
        }
    }
}

