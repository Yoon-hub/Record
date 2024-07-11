//
//  SceneDelegate.swift
//  App
//
//  Created by 윤제 on 7/8/24.
//

import UIKit

import Core

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    @Injected var appNaviagtor: AppNavigatorProtocol
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
    }
}

extension SceneDelegate {
    func registDepency() {
        let container = Container.standard
        
        container.register(type: AppNavigator.self) { _ in  AppNavigator(window: self.window!, navigationController: UINavigationController())
        }
    }
}
