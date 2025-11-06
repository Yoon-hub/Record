//
//  DiaryDIContainer.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit
import SwiftData

import Core
import Data
import Domain

final class DiaryDIContainer: BaseContainer {
    
    private func makeSaveDiaryUsecase() -> SaveDiaryUsecaseProtocol {
        SaveDiaryUsecase(repository: self.repository)
    }
    
    private func makeFetchDiaryUsecase() -> FetchDiaryUsecaseProtocol {
        FetchDiaryUsecase(repository: self.repository)
    }
    
    private func makeDeleteDiaryUsecase() -> DeleteDiaryUsecaseProtocol {
        DeleteDiaryUsecase(repository: self.repository)
    }
    
    private var repository = {
        SwiftDataRepository<Diary>()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: SaveDiaryUsecaseProtocol.self) { _ in
            self.makeSaveDiaryUsecase()
        }
        
        container.register(type: FetchDiaryUsecaseProtocol.self) { _ in
            self.makeFetchDiaryUsecase()
        }
        
        container.register(type: DeleteDiaryUsecaseProtocol.self) { _ in
            self.makeDeleteDiaryUsecase()
        }
    }
}


