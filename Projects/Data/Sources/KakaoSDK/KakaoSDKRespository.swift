//
//  KakaoSDKRespository.swift
//  Data
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import Domain

import RxSwift
import RxKakaoSDKCommon
import KakaoSDKTalk
import RxKakaoSDKTalk
import RxKakaoSDKAuth

public final class KakaoSDKRespository: KakaoSDKRepositoryProtocol {
    private static let kakoSDKAppKey = "e65abf7a0c734491e6f2309b53ed71dd"
    
    // MARK: - init
    public init () {}
    
    /// 카카오SDK 설정
    public func configureKakaoSdk() {
        RxKakaoSDK.initSDK(appKey: Self.kakoSDKAppKey)
    }
    
    /// 프로필 정보 요청
    public func profile() -> Single<TalkProfile> {
        TalkApi.shared.rx.profile()
    }
}
