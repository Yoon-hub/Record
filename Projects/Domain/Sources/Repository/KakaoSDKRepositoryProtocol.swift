//
//  KakaoSDKRepositoryProtocol.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import RxSwift

// MARK: -  카카오
import KakaoSDKTalk
import KakaoSDKAuth
import KakaoSDKFriend
import KakaoSDKTemplate
import KakaoSDKShare

public protocol KakaoSDKRepositoryProtocol {
    
    /// 카카오SDK 설정
    func configureKakaoSdk()
    
    /// 프로필 정보 요청
    func profile() -> Single<TalkProfile>
    
    /// 로그인
    func validLogin() -> Observable<OAuthToken>
    
    /// 토큰 확인
    func checkToken() -> Observable<Bool>
    
    /// 친구 목록
    func friendsPicker() -> Observable<SelectedUsers>
    
    /// - 기본 템플릿 공유하기
    /// - https://developers.kakao.com/docs/latest/ko/message/ios-link
    func shareContent(template: Templatable) -> Single<SharingResult>
    
    /// - 커스텀 템플릿 공유하기
    func shareCustomContent(args: [String: String]) -> Single<SharingResult>
    
    /// 메세지 보내기
    func sendMessage(uuid: String, template: FeedTemplate) -> Single<MessageSendResult>
    
    /// 메세지 나에게 보내기
    func sendMessageToMe(template: FeedTemplate)
}
