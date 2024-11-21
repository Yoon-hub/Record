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
            SettingTableViewCell.self,
            forCellReuseIdentifier: SettingTableViewCell.identifier
        )
        
        tableView.rowHeight = 54
        tableView.separatorStyle = .none
        
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
        self.backgroundColor = .white
        self.addSubview(tableView)
    }
    
    func setUI() {
        tableView.pin
            .all()
    }
}

