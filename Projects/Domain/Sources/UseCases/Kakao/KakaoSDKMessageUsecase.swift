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
import KakaoSDKTalk
import RxKakaoSDKTalk
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import KakaoSDKFriend

public protocol KakaoSDKMessageUsecaseProtocol {
    func executePicker() -> Observable<SelectedUsers>
}

public final class KakaoSDKMessageUsecase: KakaoSDKMessageUsecaseProtocol {
    let repository: KakaoSDKRepositoryProtocol
    
    public init(repository: KakaoSDKRepositoryProtocol) {
        self.repository = repository
    }
    
    
    public func executePicker() -> Observable<SelectedUsers> {
        repository.friendsPicker()
    }
}

