//
//  MovieView.swift
//  App
//
//  Created by 윤제 on 7/12/24.
//

import UIKit

import Design
import Core

import PinLayout

final class MovieView: UIView, BaseView {

    let collectionView: UICollectionView = {
        let spacing: CGFloat = 10
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let width = (UIScreen.main.bounds.width / 2) - (3*spacing)
        
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: width + 52)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
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
        [collectionView].forEach {addSubview( $0 ) }
    }
    
    func setUI() {
        collectionView.pin
            .all()
    }
}
