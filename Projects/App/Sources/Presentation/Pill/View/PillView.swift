//
//  PillView.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import UIKit

import Core
import Design

import PinLayout
import Lottie

final class PillView: UIView, BaseView {
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.register(
            PillTableViewCell.self,
            forCellReuseIdentifier: PillTableViewCell.identifier
        )
        
        tableView.rowHeight = 82
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    var addButton = UIButton().then {
        $0.backgroundColor = Theme.theme.withAlphaComponent(0.9)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("알리미 추가", for: .normal)
        $0.titleLabel?.font = DesignFontFamily.Pretendard.bold.font(size: 16)
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
        self.addSubview(tableView)
        self.addSubview(addButton)
    }
    
    func setUI() {
        tableView.pin
            .horizontally()
            .top()
            .bottom(to: addButton.edge.top)
        
        addButton.pin
            .horizontally()
            .bottom()
            .height(54)
    }
}

