//
//  SettingViewController.swift
//  App
//
//  Created by 윤제 on 11/19/24.
//

import UIKit

import Core

final class SettingViewController: BaseViewController<SettingReactor, SettinView> {
    
    override func setup() {
        setNavigation()
    }
    
    // MARK: - Navigation
    private func setNavigation() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "설정"
    }
}

