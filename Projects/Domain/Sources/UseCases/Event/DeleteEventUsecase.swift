//
//  DeleteEventUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/29/24.
//

import Foundation

import Core

public protocol DeleteEventUsecaseProtocol {
    func execute(event: CalendarEvent)
}

public final class DeleteEventUsecase<Repository: SwiftDataRepositoryProtocol>: DeleteEventUsecaseProtocol where Repository.T == CalendarEvent {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(event: CalendarEvent) {
        Task {
            await repository.deleteData(data: event)
            NotificationCenterService.reloadMoive.post()
        }
    }
}

