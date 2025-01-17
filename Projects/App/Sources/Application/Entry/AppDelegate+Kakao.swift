//
//  AppDelegate+Kakao.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import Foundation
import OSLog

import Domain
import Core

import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth

/// SceneDelegate로 이전
//extension AppDelegate {
//
//    private static let kakoSDKAppKey = "e65abf7a0c734491e6f2309b53ed71dd"
//    
//    /// 카카오SDK 설정
//    public func configureKakaoSdk() {
//        RxKakaoSDK.initSDK(appKey: AppDelegate.kakoSDKAppKey)
//    }
//    
//    /// 카카오 로그인 취소 핸들링
//    public func cancelKakaoLogin(_ url: URL) -> Bool {
//        if (AuthApi.isKakaoTalkLoginUrl(url)) {
//            return AuthController.handleOpenUrl(url: url)
//        }
//        return false
//    }
//    
//    /// 카카오 이벤트 공유 핸들링
//    public func shareKakaoEvent(_ url: URL) -> Bool {
//        let params = getQueryItems(url)
//        
//        let result = EventBuilder()
//            .buildWithDictionary(params)
//        
//        switch result {
//        case .success(let event):
//            @Injected var provider: GlobalStateProvider
//            @Navigator var appNaviagtor: AppNavigatorProtocol
//            
//            // window 초기화
//            appNaviagtor.toTest()
//            
//            delay(0.3) {
//                // window 초기화 후 kakao Event 발생
//                provider.sendEvent(.didRecivekakaoAppScheme(event))
//            }
//            // 이벤트 전달
//            provider.sendEvent(.didRecivekakaoAppScheme(event))
//            return true
//        case .failure(let error):
//            return false
//        }
//    }
//    
//    /// URL -> QureryItems
//    public func getQueryItems(_ url: URL) -> [String: String] {
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
//              let queryItems = components.queryItems else {
//            print("Invalid URL")
//            return [:]
//        }
//        
//        var params: [String: String] = [:]
//        for item in queryItems {
//            params[item.name] = item.value
//        }
//        
//        return params
//    }
//
//}
