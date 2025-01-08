//
//  AppDelegate+Kakao.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import RxKakaoSDKCommon

extension AppDelegate {
    
    private static let kakoSDKAppKey = "e65abf7a0c734491e6f2309b53ed71dd"
    
    /// 카카오SDK 설정
    func configureKakaoSdk() {
        RxKakaoSDK.initSDK(appKey: AppDelegate.kakoSDKAppKey)
    }
}
