//
//  SceneDelegate+Kakao.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

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
}

