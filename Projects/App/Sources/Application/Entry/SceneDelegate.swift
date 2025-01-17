//
//  SceneDelegate.swift
//  App
//
//  Created by 윤제 on 7/8/24.
//

import UIKit
import OSLog
import WidgetKit

import Core

class SceneDelegate: UIResponder, UIWindowSceneDelegate, WidgetReloadProtocol {
    
    var window: UIWindow?
    
    @Navigator var appNaviagtor: AppNavigatorProtocol
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        registDepency(scene: scene)
        appNaviagtor.toTabBar()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenterService.reloadCalendar.post()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        reloadWidget()
    }
    
    /// KaKaoSDK
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        print("⚙️⚙️⚙️⚙️ Sceme: \(URLContexts)")
        
        // 로그인 취소 핸들링
        cancelKakaoLogin(URLContexts)
        
        // 이벤트 공유 핸들링
        shareKakaoEvent(URLContexts)
    }
    
    /// Not Running 상태에서 Scheme 핸들링
    private func handleAppScheme(connectionOptions: UIScene.ConnectionOptions) {
        if let urlContext = connectionOptions.urlContexts.first {
            os_log("🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶 Scene \(urlContext)")
            shareKakaoEvent(Set([urlContext]))
        }
    }
}

extension SceneDelegate {
    func registDepency(scene: UIScene) {
        let container = Container.standard
        
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        self.window = window
        
        container.register(type: UIWindow.self) { _ in window }
        
        NaviagtionDIContainer(mainNavigatorNaviagtionController: UINavigationController(), calendarNavigatorNaviagtionController: UINavigationController()).registerDependencies()
    }
}
