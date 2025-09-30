//
//  MetamonDIContainer.swift
//  App
//
//  Created by 윤제 on 9/30/25.
//

import UIKit
import SwiftData

import Core
import Data
import Domain

final class MetamonDIContainer: BaseContainer {
    
    private func makeSaveMetamonUsecase() -> SaveMetamonUsecaseProtocol {
        SaveMetamonUsecase(repository: self.repository)
    }
    
    private func makeFetchMetamonUsecase() -> FetchMetamonUsecaseProtocol {
        FetchMetamonUsecase(repository: self.repository)
    }
    
    private func makeUpdateMetamonUsecase() -> UpdateMetamonUsecaseProtocol {
        UpdateMetamonUsecase(repository: self.repository)
    }
    
    private func makeDeleteMetamonUsecase() -> DeleteMetamonUsecaseProtocol {
        DeleteMetamonUsecase(repository: self.repository)
    }
    
    private var repository = {
        SwiftDataRepository<Metamon>()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: SaveMetamonUsecaseProtocol.self) { _ in
            self.makeSaveMetamonUsecase()
        }
        
        container.register(type: FetchMetamonUsecaseProtocol.self) { _ in
            self.makeFetchMetamonUsecase()
        }
        
        container.register(type: UpdateMetamonUsecaseProtocol.self) { _ in
            self.makeUpdateMetamonUsecase()
        }
        
        container.register(type: DeleteMetamonUsecaseProtocol.self) { _ in
            self.makeDeleteMetamonUsecase()
        }
    }
}
