//
//  TabBar.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setTabbar()
        }
        
        private func setTabbar() {
            
            // 디폴트 색상 설정
            tabBar.backgroundColor = UIColor.white.withAlphaComponent(0.4) // 탭 바의 배경 색상
            
            tabBar.unselectedItemTintColor = UIColor.gray // 선택되지 않은 아이템의 색상

             // 선택된 아이템의 색상 설정
            tabBar.tintColor = UIColor(named: "mainColor") // 선택된 아이템의 색상
            
//            // movie
//            let movieVC = MovieViewController(viewModel: MovieViewModel())
//            let movieNavi = UINavigationController(rootViewController: movieVC)
//            movieNavi.tabBarItem = UITabBarItem(title: "영화", image: resizeImage(image: UIImage(named: "movieIcon")!, targetSize: CGSize(width: 22, height: 22)), tag: 0)
//            
//            // museum
//            let museumVC = MuseumViewController()
//            museumVC.tabBarItem = UITabBarItem(title: "뮤지엄", image: resizeImage(image: UIImage(named: "museumIcon")!, targetSize: CGSize(width: 22, height: 22)), tag: 1)
            
            self.viewControllers = []
        }
}
