//
//  EventDIContainer.swift
//  App
//
//  Created by 윤제 on 8/23/24.
//

import UIKit
import SwiftData

import Core
import Data
import Domain

final class EventDIContainer: BaseContainer {
    
    private func makeSaveEventUsecase() -> SaveEventUsecaseProtocol {
        SaveEventUsecase(repository: self.repository)
    }
    
    private func makeFetchEventUsecase() -> FetchEventUsecaseProtocol {
        FetchEventUsecase(repository: self.repository)
    }
    
    private func makeDeleteEventUsecase() -> DeleteEventUsecaseProtocol {
        DeleteEventUsecase(repository: self.repository)
    }
    
    private var repository = {
        SwiftDataRepository<CalendarEvent>()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: SaveEventUsecaseProtocol.self) { _ in
            self.makeSaveEventUsecase()
        }
        
        container.register(type: FetchEventUsecaseProtocol.self) { _ in
            self.makeFetchEventUsecase()
        }
        
        container.register(type: DeleteEventUsecaseProtocol.self) { _ in
            self.makeDeleteEventUsecase()
        }
        
        /// Global State
        container.register(type: GlobalStateProvider.self) { _ in
            GlobalStateProviderImpl()
        }
    }
}
