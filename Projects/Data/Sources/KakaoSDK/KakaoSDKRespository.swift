//
//  KakaoSDKRespository.swift
//  Data
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import Domain

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

import KakaoSDKFriend
import KakaoSDKFriendCore
import RxKakaoSDKFriend

public final class KakaoSDKRespository: KakaoSDKRepositoryProtocol {
    private static let kakoSDKAppKey = "e65abf7a0c734491e6f2309b53ed71dd"
    
    // MARK: - init
    public init () {}
    
    // MARK: - Login
    /// 카카오SDK 설정
    public func configureKakaoSdk() {
        RxKakaoSDK.initSDK(appKey: Self.kakoSDKAppKey)
    }
    
    /// 프로필 정보 요청
    public func profile() -> Single<TalkProfile> {
        TalkApi.shared.rx.profile()
    }
    
    /// Kakao 로그인 가능여부 확인
    public func validLogin() -> Observable<OAuthToken> {
        UserApi.shared.rx.loginWithKakaoTalk()
    }
    
    /// 토큰 여부 확인
    public func checkToken() -> Observable<Bool> {
        if (AuthApi.hasToken()) {
            return UserApi.shared.rx.accessTokenInfo()
                .asObservable()
                .flatMap{ _ in Observable.just(true) }
                .catch { _ in Observable.just(false) }
        } else {
            return Observable.just(false)
        }
    }
    
    
    // MARK: - Message
    
    /// 친구 목록
    public func friendsPicker() -> Observable<SelectedUsers> {
        let openPickerFriendRequestParams = OpenPickerFriendRequestParams(
            title: "싱글 피커",
            viewAppearance: .dark,
            orientation: .portrait,
            enableSearch: true,
            enableIndex: true,
            showFavorite: true
        )
        
        return PickerApi.shared.rx.selectFriendPopup(params: openPickerFriendRequestParams)
    }
}
