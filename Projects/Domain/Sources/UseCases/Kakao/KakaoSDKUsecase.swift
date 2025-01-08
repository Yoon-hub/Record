//
//  KakaoSDKUsecase.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import RxSwift
import KakaoSDKTalk

public protocol KakaoSDKUsecaseProtocol {
    func executeConfigure()
    func excuteProfile() -> Single<TalkProfile>
}

public final class KakaoSDKUsecase: KakaoSDKUsecaseProtocol {
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
}
