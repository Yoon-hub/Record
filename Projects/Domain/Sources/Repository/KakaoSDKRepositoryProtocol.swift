//
//  KakaoSDKRepositoryProtocol.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import RxSwift
import KakaoSDKTalk
import KakaoSDKAuth
import KakaoSDKFriend

public protocol KakaoSDKRepositoryProtocol {
    
    /// 카카오SDK 설정
    func configureKakaoSdk()
    
    /// 프로필 정보 요청
    func profile() -> Single<TalkProfile>
    
    /// 로그인
    func validLogin() -> Observable<OAuthToken>
    
    /// 토큰 확인
    func checkToken() -> Observable<Bool>
    
    /// 친구 목록/
    func friendsPicker() -> Observable<SelectedUsers>
}
