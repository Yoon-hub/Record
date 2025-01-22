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
import KakaoSDKCommon
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
import KakaoSDKShare
import RxKakaoSDKShare
import KakaoSDKTemplate


public final class KakaoSDKRespository: KakaoSDKRepositoryProtocol {
    private static let kakoSDKAppKey = "e65abf7a0c734491e6f2309b53ed71dd"
    
    /// `https://developers.kakao.com/tool/template-builder/app/779552/template/116289`
    private static let customTemplateID: Int64 = 116289
    
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
            title: "친구 목록",
            viewAppearance: .light,
            orientation: .auto,
            enableSearch: false,
            enableIndex: true,
            showFavorite: true
        )
        
        return PickerApi.shared.rx.selectFriendPopup(params: openPickerFriendRequestParams)
    }
    
    /// 공유하기 디폴트
    public func shareContent(template: Templatable) -> Single<SharingResult> {
        return ShareApi.shared.rx.shareDefault(templatable: template)
    }
    
    /// 공유하기 커스텀
    public func shareCustomContent(args: [String: String]) -> Single<SharingResult> {
        return ShareApi.shared.rx.shareCustom(templateId: Self.customTemplateID, templateArgs: args)
    }
    
    
    // MARK: - 앱 권한 신청 해야 사용할 수 있는 기능 🥹
    
    /// 친구에게 메세지 보내기
    public func sendMessage(
        uuid: String,
        template: FeedTemplate
    ) -> Single<MessageSendResult> {
        return TalkApi.shared.rx.sendDefaultMessage(
            templatable: template,
            receiverUuids: [uuid]
        )
    }
    
    /// 나에게 메세지 보내기
    public func sendMessageToMe(template: FeedTemplate) {
        TalkApi.shared.sendDefaultMemo(templatable: template) {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("success.")
            }
        }
    }
    
}
