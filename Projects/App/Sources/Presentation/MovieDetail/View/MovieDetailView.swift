//
//  MovieDetailView.swift
//  App
//
//  Created by 윤제 on 7/31/24.
//

import UIKit

import Core
import Domain
import Design

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
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 19, weight: .semibold)
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = .systemFont(ofSize: 11)
    }
    
    let contentLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
    }
    
    let heartButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        $0.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfig), for: .normal)
        $0.tintColor = DesignAsset.record.color
        $0.adjustsImageWhenHighlighted = false
        $0.isHidden = true
    }
    
    let heartLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 14)
        $0.isHidden = true
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
        [focusCollectionView, titleLabel, dateLabel, contentLabel, heartButton, heartLabel].forEach { addSubview($0) }
    }
    
    func setUI() {
        focusCollectionView.pin
            .top()
            .horizontally()
            .height(UIScreen.main.bounds.height / 2.5)
        
        titleLabel.pin
            .below(of: focusCollectionView)
            .marginTop(0)
            .hCenter(to: self.edge.hCenter)
            .sizeToFit()
        
        dateLabel.pin
            .below(of: titleLabel)
            .marginTop(0)
            .hCenter(to: self.edge.hCenter)
            .sizeToFit()
        
        contentLabel.pin
            .below(of: dateLabel)
            .marginTop(12)
            .horizontally(16)
            .sizeToFit(.width)
            
        heartButton.pin
            .bottom(120)
            .height(27)
            .width(30)
            .hCenter(to: self.edge.hCenter)
        
        heartLabel.pin
            .above(of: heartButton)
            .marginTop(4)
            .horizontally()
            .height(20)
    }
    
    func bind(movie: Movie) {
        titleLabel.text = movie.title
        dateLabel.text = movie.date.formattedDateString()
        contentLabel.text = movie.content
        heartLabel.text = "\(movie.heart)"
    }
}
