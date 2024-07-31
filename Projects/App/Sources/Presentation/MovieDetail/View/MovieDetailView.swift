//
//  MovieDetailView.swift
//  App
//
//  Created by 윤제 on 7/31/24.
//

import UIKit

import Core

import PinLayout
import FocusCollectionView

final class MovieDetailView: UIView, BaseView {
    
    let focusCollectionView: FocusCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionViewHorizontalSize = UIScreen.main.bounds.width / 2.1
        flowLayout.itemSize = CGSize(width: collectionViewHorizontalSize, height: collectionViewHorizontalSize)
        flowLayout.minimumLineSpacing = 60
        
        flowLayout.scrollDirection = .horizontal
        let focusCollectionView = FocusCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        focusCollectionView.isShadowEnabled = true
        focusCollectionView.focusScale = 1.1
        focusCollectionView.showsHorizontalScrollIndicator = false
        focusCollectionView.isPrefetchingEnabled = false
        focusCollectionView.register(MovieDetailCollectionViewCell.self, forCellWithReuseIdentifier: MovieDetailCollectionViewCell.identifier)
        return focusCollectionView
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
        [focusCollectionView].forEach { addSubview($0) }
    }
    
    func setUI() {
        focusCollectionView.pin
            .top()
            .horizontally()
            .height(UIScreen.main.bounds.height / 2.6)
    }
}
