//
//  EventCollectionViewCell.swift
//  App
//
//  Created by 윤제 on 8/19/24.
//

import UIKit

import Core

final class EventCollectionViewCell: UITableViewCell, BaseView {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0))
    }
    
    func configure() {
        contentView.backgroundColor = .systemGray6.withAlphaComponent(0.5)
        self.selectionStyle = .none
        
        contentView.layer.cornerRadius = 8
    }
    
    func setUI() {
        
    }
    
}
