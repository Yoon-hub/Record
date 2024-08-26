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
    
    
    private var repository = {
        SwiftDataRepository<CalendarEvent>()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: SaveEventUsecaseProtocol.self) { _ in
            self.makeSaveEventUsecase()
        }
    }
}
