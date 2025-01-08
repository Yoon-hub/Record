//
//  KakaoSDKRepositoryProtocol.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import RxSwift
import KakaoSDKTalk

public protocol KakaoSDKRepositoryProtocol {
    
    /// 카카오SDK 설정
    func configureKakaoSdk()
    
    /// 프로필 정보 요청
    func profile() -> Single<TalkProfile>

}
