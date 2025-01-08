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
    
    private func makeKakaoSDKUsecase() -> KakaoSDKUsecaseProtocol {
        KakaoSDKUsecase(repository: self.repository)
    }
    
    private var repository: KakaoSDKRepositoryProtocol = {
        KakaoSDKRespository()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: KakaoSDKUsecaseProtocol.self) { _ in
            self.makeKakaoSDKUsecase()
        }
    }
}

