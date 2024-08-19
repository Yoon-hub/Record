//
//  MovieAddView.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import UIKit

import Design
import Core

import PinLayout

final class MovieAddView: UIView, BaseView {
    
    let imageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.itemSize = CGSize(width: 72, height: 72)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieAddCollectionViewCell.self, forCellWithReuseIdentifier: MovieAddCollectionViewCell.identifier)
        return collectionView
    }()
    
    let imagePlusButton = UIButton().then {
        $0.tintColor = .systemGray4
        $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 10
    }
    
    let firstStarButton = UIButton().then {
        $0.tintColor = .systemGray4
        $0.setImage(DesignAsset.star.image, for: .normal)
    }
    
    let secondStarButton = UIButton().then {
        $0.tintColor = .systemGray4
        $0.setImage(DesignAsset.star.image, for: .normal)
    }
    
    let thirdStarButton = UIButton().then {
        $0.tintColor = .systemGray4
        $0.setImage(DesignAsset.star.image, for: .normal)
    }
    
    let fourthStarButton = UIButton().then {
        $0.tintColor = .systemGray4
        $0.setImage(DesignAsset.star.image, for: .normal)
    }
    
    let fifthStarButton = UIButton().then {
        $0.tintColor = .systemGray4
        $0.setImage(DesignAsset.star.image, for: .normal)
    }
    
    let titleTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
                  string: "title",
                  attributes: [
                      .foregroundColor: UIColor.systemGray3, // 원하는 색상
                      .font: UIFont.systemFont(ofSize: 15) // 원하는 폰트
                  ]
              )
    }
    
    let datePicker = UIDatePicker(frame: .zero).then {
        $0.datePickerMode = .date
    }
    
    let dateLabel = UILabel().then {
        $0.text = "\(Date().formattedDateString(type: .yearMonthDay))"
        $0.backgroundColor = .white
        $0.textColor = UIColor.systemGray3
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    lazy var contentTextView = UITextView().then {
        $0.textContainerInset = .zero  // 여백 설정
        $0.textContainer.lineFragmentPadding = 0  // 여백 설정
        $0.text = textViewPlaceHolderText
        $0.textColor = .systemGray3
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    let textViewPlaceHolderText = "content      "
    
    var keyBoardHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    func setUI() {
        self.backgroundColor = .white
        [imagePlusButton, imageCollectionView, titleTextField, datePicker, contentTextView, firstStarButton, secondStarButton, thirdStarButton, fourthStarButton, fifthStarButton, dateLabel].forEach { self.addSubview($0) }
    }
    
    func configure() {
        
        imagePlusButton.pin
            .top(104)
            .left(16)
            .size(68)
        
        imageCollectionView.pin
            .vCenter(to: imagePlusButton.edge.vCenter)
            .after(of: imagePlusButton)
            .marginLeft(16)
            .right(16)
            .height(104)
        
        datePicker.pin
            .below(of: imageCollectionView)
            .marginTop(24)
            .right(16)
            .height(40)
            .width(78)
        
        firstStarButton.pin
            .below(of: imageCollectionView)
            .marginTop(24)
            .left(24)
            .height(20)
            .width(20)
        
        dateLabel.pin
            .below(of: imageCollectionView)
            .marginTop(13)
            .right(16)
            .height(40)
            .width(82)
        
        secondStarButton.pin
            .after(of: firstStarButton)
            .marginLeft(1)
            .height(20)
            .width(20)
            .vCenter(to: firstStarButton.edge.vCenter)
        
        thirdStarButton.pin
            .after(of: secondStarButton)
            .marginLeft(1)
            .height(20)
            .width(20)
            .vCenter(to: firstStarButton.edge.vCenter)
        
        fourthStarButton.pin
            .after(of: thirdStarButton)
            .marginLeft(1)
            .height(20)
            .width(20)
            .vCenter(to: firstStarButton.edge.vCenter)
        
        fifthStarButton.pin
            .after(of: fourthStarButton)
            .marginLeft(1)
            .height(20)
            .width(20)
            .vCenter(to: firstStarButton.edge.vCenter)
        
            
        titleTextField.pin
            .below(of: firstStarButton)
            .marginTop(24)
            .horizontally(24)
            .height(40)

        contentTextView.pin
            .below(of: titleTextField)
            .marginTop(16)
            .horizontally(24)
            .bottom(36 + keyBoardHeight)
    }
}

extension MovieAddView {
    
    func keyBoardActive(keyBoardHeight: CGFloat) {
        self.keyBoardHeight = keyBoardHeight
        self.configure()
    }
}

