//
//  NaviagtionDIContainer.swift
//  App
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

import Core

final class NaviagtionDIContainer: BaseContainer {
    
    @Injected var window: UIWindow
    
    var mainNavigatorNaviagtionController: UINavigationController
    var calendarNavigatorNaviagtionController: UINavigationController
    var diaryNavigatorNavigationController: UINavigationController
    
    init(mainNavigatorNaviagtionController: UINavigationController, calendarNavigatorNaviagtionController: UINavigationController, diaryNavigatorNavigationController: UINavigationController) {
        self.mainNavigatorNaviagtionController = mainNavigatorNaviagtionController
        self.calendarNavigatorNaviagtionController = calendarNavigatorNaviagtionController
        self.diaryNavigatorNavigationController = diaryNavigatorNavigationController
    }
    
    func registerDependencies() {
        container.register(type: AppNavigatorProtocol.self) { _ in
            AppNavigator(window: window)
        }
        
        container.register(type: MainNaviagatorProtocol.self) { _ in
            MainNaviagator(navigationController: mainNavigatorNaviagtionController)
        }
        
        container.register(type: CalendarNavigatorProtocol.self) { _ in
            CalendarNavigator(navigationController: calendarNavigatorNaviagtionController)
        }
        
        container.register(type: DiaryNavigatorProtocol.self) { _ in
            DiaryNavigator(navigationController: diaryNavigatorNavigationController)
        }
    }
}
