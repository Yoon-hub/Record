//
//  AppNavigator.swift
//  App
//
//  Created by 윤제 on 7/8/24.
//

import Core
import UIKit

protocol AppNavigatorProtocol: BaseNavigator {
    
    var window: UIWindow { get set }
    
    func toTabBar()
}

final class AppNavigator: AppNavigatorProtocol {
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    init(
        window: UIWindow,
        navigationController: UINavigationController
    ) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func toTabBar() {
        let vc = TabBarViewControllerWrapper().viewController
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
