//
//  AppNavigator.swift
//  App
//
//  Created by 윤제 on 7/8/24.
//

import UIKit

import Core

protocol AppNavigatorProtocol {
    
    var window: UIWindow { get set }
    
    func toTabBar()
}

final class AppNavigator: AppNavigatorProtocol {
    
    var window: UIWindow
    
    init(
        window: UIWindow
    ) {
        self.window = window
    }
    
    func toTabBar() {
        let vc = TabBarViewControllerWrapper().viewController
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
