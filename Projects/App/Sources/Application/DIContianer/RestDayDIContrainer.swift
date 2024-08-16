//
//  RestDayContrainer.swift
//  App
//
//  Created by 윤제 on 8/14/24.
//

import UIKit
import SwiftData

import Core
import Data
import Domain

final class RestDayDIContrainer: BaseContainer {
    
    private func makeSaveRestDayUsecase() -> SaveRestUsecaseProtocol {
        SaveRestDayUsecase (
            repository: self.swiftDataRepository
        )
    }
    
    private func makeFetchRestDayFromDBUsecase() -> FetchRestDayFromDBUsecaserotocol {
        FetchRestDayFromDBUsecase(
            repository: self.swiftDataRepository
        )
    }
    
    private func makeFetchRestDayUsecase() -> FetchRestDayUsecaseProtocol {
        FetchRestDayUsecase(
            repository: self.RestDayRePository
        )
    }
    
    private var swiftDataRepository = {
        SwiftDataRepository<RestDay>()
    }()
    
    private var RestDayRePository = {
        RestDayRepository()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: SaveRestUsecaseProtocol.self) { _ in
            self.makeSaveRestDayUsecase()
        }
        
        container.register(type: FetchRestDayUsecaseProtocol.self) { _ in
            self.makeFetchRestDayUsecase()
        }
        
        container.register(type: FetchRestDayFromDBUsecaserotocol.self) { _ in
            self.makeFetchRestDayFromDBUsecase()
        }
    }
}

