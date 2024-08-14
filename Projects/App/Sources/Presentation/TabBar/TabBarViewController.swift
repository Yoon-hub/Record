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
    
    @Navigator var mainNaivagtor: MainNaviagatorProtocol
    @Navigator var calendarNavigator: CalendarNavigatorProtocol
    
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
            movie.tabBarItem = UITabBarItem(title: "영화", image: UIImage(systemName: "tray.fill"), tag: 0)
            
            // calendar
            let calendar = CalendarViewControllerWrapper().viewController
            calendar.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 1)
            
            let naviMovie = mainNaivagtor.navigationController
            naviMovie.viewControllers = [movie]
            
            let naviCalendar = calendarNavigator.navigationController
            naviCalendar.viewControllers = [calendar]
            
            self.viewControllers = [naviCalendar, naviMovie]
        }
    
}
