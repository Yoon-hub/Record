//
//  KakaoSDKError.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

/// 카카오 SDK에서 활용할 error type
public enum KakaoSDKError: Error {
    case inAvalableLogin
    case inValidToken
    case inValidTemplate
}
