//
//  TabBarViewContollerWrapper.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

final class TabBarViewControllerWrapper {
    
    func makeViewController() -> UITabBarController {
        return TabBarViewController()
    }
    
    var viewController: UITabBarController {
        makeViewController()
    }
}
