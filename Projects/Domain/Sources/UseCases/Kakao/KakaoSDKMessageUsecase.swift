//
//  KakaoSDKMessageUsecase.swift
//  Domain
//
//  Created by 윤제 on 1/9/25.
//

import Foundation

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
import KakaoSDKShare
import KakaoSDKTemplate

public protocol KakaoSDKMessageUsecaseProtocol {
    func executePicker() -> Observable<SelectedUsers>
    func executeShareContent(template: Data) -> Single<SharingResult>
    
    func excuteSendMessage(uuid: String, template: Data) -> Single<MessageSendResult>
    func excuteSendMessageToMe(template: Data)
    func executeShareCustomContent(args: [String: String]) -> Observable<SharingResult>
}

public final class KakaoSDKMessageUsecase: KakaoSDKMessageUsecaseProtocol {
    let repository: KakaoSDKRepositoryProtocol
    
    public init(repository: KakaoSDKRepositoryProtocol) {
        self.repository = repository
    }
    
    
    public func executePicker() -> Observable<SelectedUsers> {
        repository.friendsPicker()
    }
    
    public func executeShareContent(template: Data) -> Single<SharingResult> {
        
        guard let templatable = try? SdkJSONDecoder.custom.decode(
            FeedTemplate.self,
            from: template
        ) else {
            return Single.error(KakaoSDKError.inValidTemplate)
        }
        
        return repository.shareContent(template: templatable)
    }
    
    public func excuteSendMessage(
        uuid: String,
        template: Data
    ) -> Single<MessageSendResult> {
        
        guard let templatable = try? SdkJSONDecoder.custom.decode(
            FeedTemplate.self,
            from: template
        ) else {
            return Single.error(KakaoSDKError.inValidTemplate)
        }
        
        return repository.sendMessage(
            uuid: uuid,
            template: templatable
        )
    }
    
    public func excuteSendMessageToMe(template: Data) {
        
        guard let templatable = try? SdkJSONDecoder.custom.decode(
            FeedTemplate.self,
            from: template
        ) else {
            return
        }
        
        repository.sendMessageToMe(template: templatable)
    }
    
    public func executeShareCustomContent(args: [String: String]) -> Observable<SharingResult> {
        repository.shareCustomContent(args: args)
            .asObservable()
    }
    
}

