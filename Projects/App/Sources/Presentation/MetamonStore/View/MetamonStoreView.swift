//
//  MetamonStoreView.swift
//  App
//
//  Created by 윤제 on 10/1/25.
//

import UIKit

import Core
import Design

import PinLayout
import RxSwift
import RxCocoa

final class MetamonStoreView: UIView, BaseView {
    
    let closeButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .light)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: .normal)
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    let pointLabel = UILabel().then {
        $0.font = DesignFontFamily.PressStart2P.regular.font(size: 12)
        $0.text = "POINT: 1,000"
    }
    
    let collectionView: UICollectionView = {
        let spacing: CGFloat = 10
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 16
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let width = (UIScreen.main.bounds.width / 2) - (3*spacing)
        
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: width)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(MetamonStoreCell.self, forCellWithReuseIdentifier: MetamonStoreCell.identifier)
        return collectionView
    }()
    
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
        
        [closeButton, pointLabel, collectionView].forEach { self.addSubview($0) }

    }

    func setUI() {
        closeButton.pin
            .top(64)
            .right(16)
            .size(26)
        
        pointLabel.pin
            .vCenter(to: closeButton.edge.vCenter)
            .left(20)
            .width(200)
            .sizeToFit(.width)
        
        collectionView.pin
            .below(of: pointLabel)
            .marginTop(16)
            .horizontally()
            .bottom()
    }
    
}

