//
//  SaveEventUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/23/24.
//

import Foundation

public protocol SaveEventUsecaseProtocol {
    func excecute(event: CalendarEvent)
}

public final class SaveEventUsecase<Repository: SwiftDataRepositoryProtocol>: SaveEventUsecaseProtocol where Repository.T == CalendarEvent {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func excecute(event: CalendarEvent) {
        Task {
            await repository.insertData(data: event)
        }
    }
}
