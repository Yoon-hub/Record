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
    @Injected var naviagtionController: UINavigationController
    
    func registerDependencies() {
        container.register(type: AppNavigatorProtocol.self) { _ in
            AppNavigator(window: window, navigationController: naviagtionController)
        }
    }
}
