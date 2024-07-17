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
    
    init(mainNavigatorNaviagtionController: UINavigationController) {
        self.mainNavigatorNaviagtionController = mainNavigatorNaviagtionController
    }
    
    func registerDependencies() {
        container.register(type: AppNavigatorProtocol.self) { _ in 
            AppNavigator(window: window)
        }
        
        container.register(type: MainNaviagatorProtocol.self) { _ in
            MainNaviagator(navigationController: mainNavigatorNaviagtionController)
        }
    }
}
