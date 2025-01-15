//
//  SceneDelegate+Kakao.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Domain
import Core

import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth

extension SceneDelegate {
    
    /// 카카오 로그인 취소 핸들링
    public func cancelKakaoLogin(_ URLContexts: Set<UIOpenURLContext>)  {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    /// 카카오 이벤트 공유 핸들링
    public func shareKakaoEvent(_ URLContexts: Set<UIOpenURLContext>) {
        let params = getQueryItems(URLContexts)
        
        let result = EventBuilder()
            .buildWithDictionary(params)
        
        switch result {
        case .success(let event):
            @Injected var provider: GlobalStateProvider
            
            // window 초기화
            appNaviagtor.toTabBar()
            
            // 이벤트 전달 
            provider.sendEvent(.didRecivekakaoAppScheme(event))
            
        case .failure(let error):
            return
        }
        
    }
    
    /// URLContexts -> QureryItems
    public func getQueryItems(_ URLContexts: Set<UIOpenURLContext>) -> [String: String] {
        guard let url = URLContexts.first?.url else { return [:] }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            print("Invalid URL")
            return [:]
        }
        
        var params: [String: String] = [:]
        for item in queryItems {
            params[item.name] = item.value
        }
        
        return params
    }
}

