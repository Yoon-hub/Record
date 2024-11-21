//
//  PillDIContainer.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import UIKit
import SwiftData

import Core
import Data
import Domain

final class PillDIContainer: BaseContainer {
    
    private func makeSaveEventUsecase() -> SavePillUsecaseProtocol {
        SavePillUsecase(repository: self.repository)
    }
    
    private func makeFetchEventUsecase() -> FetchPillUsecaseProtocol {
        FetchPillUsecase(repository: self.repository)
    }
    
    private func makeDeleteEventUsecase() -> DeletePillUsecaseProtocol {
        DeletePillUsecase(repository: self.repository)
    }
    
    private var repository = {
        SwiftDataRepository<Pill>()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: SavePillUsecaseProtocol.self) { _ in
            self.makeSaveEventUsecase()
        }
        
        container.register(type: FetchPillUsecaseProtocol.self) { _ in
            self.makeFetchEventUsecase()
        }
        
        container.register(type: DeletePillUsecaseProtocol.self) { _ in
            self.makeDeleteEventUsecase()
        }
    }
}

