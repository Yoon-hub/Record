//
//  AppDelegate.swift
//  App
//
//  Created by 윤제 on 7/8/24.
//

import UIKit

import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let containers: [BaseContainer] = [
            MovieDIContainer()
        ]
        containers.forEach {
            $0.registerDependencies()
        }
        
        return true
    }
}
