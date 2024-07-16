//
//  TabBar.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

import Core
import Design

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setTabbar()
        }
        
        private func setTabbar() {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            tabBar.scrollEdgeAppearance = appearance
            
            tabBar.tintColor = .recordColor
            
            // movie
            let movie = MovieViewControllerWrapper().viewController
            movie.tabBarItem = UITabBarItem(title: "영화", image: DesignAsset.movie.image.resize(targetSize: CGSize(width: 30, height: 30)), tag: 0)
            
            let movieNavi = UINavigationController(rootViewController: movie)
            
            self.viewControllers = [movieNavi]
        }
    
}
