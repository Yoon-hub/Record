//
//  KakaSDKDIContainer.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit
import SwiftData

import Core
import Data
import Domain

final class KakaSDKDIContainer: BaseContainer {
    
    private func makeKakaoSDKLoginUsecase() -> KakaoSDKLoginUsecaseProtocol {
        KakaoSDKLoginUsecase(repository: self.repository)
    }
    
    private func makeKakaoSDKMesageUsecase() -> KakaoSDKMessageUsecaseProtocol {
        KakaoSDKMessageUsecase(repository: self.repository)
    }
    
    private var repository: KakaoSDKRepositoryProtocol = {
        KakaoSDKRespository()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: KakaoSDKLoginUsecaseProtocol.self) { _ in
            self.makeKakaoSDKLoginUsecase()
        }
        
        container.register(type: KakaoSDKMessageUsecaseProtocol.self) { _ in
            self.makeKakaoSDKMesageUsecase()
        }
    }
}

