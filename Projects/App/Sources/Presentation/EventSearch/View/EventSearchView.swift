//
//  EventSearchView.swift
//  App
//

import UIKit

import Core
import Design

import PinLayout

final class EventSearchView: UIView, BaseView {
    
    let searchTextField = UITextField().then {
        $0.placeholder = "제목 또는 메모로 검색"
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 16)
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .search
        $0.autocorrectionType = .no
    }
    
    private let searchContainer = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
    }
    
    private let searchIcon = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = .secondaryLabel
        $0.contentMode = .scaleAspectFit
    }
    
    /// 날짜별로 스크롤 이동용 칩 (검색 결과가 있을 때만 표시)
    private let dateTabLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    lazy var dateTabCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: dateTabLayout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = true
        cv.register(EventSearchDateChipCell.self, forCellWithReuseIdentifier: EventSearchDateChipCell.identifier)
        cv.isHidden = true
        return cv
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            EventSearchEventCell.self,
            forCellReuseIdentifier: EventSearchEventCell.identifier
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 112
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionHeaderTopPadding = 12
        return tableView
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
        backgroundColor = .systemGroupedBackground
        addSubview(searchContainer)
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        addSubview(dateTabCollectionView)
        addSubview(tableView)
    }
    
    func setDateTabsVisible(_ visible: Bool) {
        dateTabCollectionView.isHidden = !visible
        setNeedsLayout()
    }
    
    func setUI() {
        searchContainer.pin
            .top(pin.safeArea)
            .horizontally(16)
            .height(44)
        
        searchIcon.pin
            .vCenter()
            .left(12)
            .size(18)
        
        searchTextField.pin
            .after(of: searchIcon)
            .marginLeft(8)
            .right(12)
            .vCenter()
            .height(36)
        
        if dateTabCollectionView.isHidden {
            tableView.pin
                .below(of: searchContainer)
                .marginTop(12)
                .horizontally()
                .bottom()
            dateTabCollectionView.pin.size(0)
        } else {
            dateTabCollectionView.pin
                .below(of: searchContainer)
                .marginTop(8)
                .horizontally()
                .height(40)
            
            tableView.pin
                .below(of: dateTabCollectionView)
                .marginTop(4)
                .horizontally()
                .bottom()
        }
    }
}
