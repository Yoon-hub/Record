//
//  AppDelegate+Kakao.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth

extension AppDelegate {
    
    private static let kakoSDKAppKey = "e65abf7a0c734491e6f2309b53ed71dd"
    
    /// 카카오SDK 설정
    public func configureKakaoSdk() {
        RxKakaoSDK.initSDK(appKey: AppDelegate.kakoSDKAppKey)
    }
    
    /// 카카오 로그인 취소 핸들링
    public func cancelKakaoLogin(_ url: URL) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }

}
