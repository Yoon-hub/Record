//
//  KakaoSDKUsecase.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import RxSwift

// MARK: - Kakao SDK
import RxKakaoSDKCommon
import KakaoSDKTalk
import RxKakaoSDKTalk
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

public protocol KakaoSDKLoginUsecaseProtocol {
    func executeConfigure()
    func excuteProfile() -> Single<TalkProfile>
    func executeValidLogin() -> Observable<OAuthToken>
    func executeCheckToken() -> Observable<Bool>
}

public final class KakaoSDKLoginUsecase: KakaoSDKLoginUsecaseProtocol {
    let repository: KakaoSDKRepositoryProtocol
    
    public init(repository: KakaoSDKRepositoryProtocol) {
        self.repository = repository
    }
    
    public func executeConfigure() {
        repository.configureKakaoSdk()
    }
    
    public func excuteProfile() -> Single<TalkProfile> {
        repository.profile()
    }
    
    public func executeValidLogin() -> Observable<OAuthToken> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return repository.validLogin()
        } else {
            return Observable.error(KakaoSDKError.inAvalableLogin)
        }
    }
    
    public func executeCheckToken() -> Observable<Bool> {
        repository.checkToken()
    }
}
