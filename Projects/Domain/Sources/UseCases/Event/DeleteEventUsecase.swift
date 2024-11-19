//
//  DeleteEventUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/29/24.
//

import Foundation

import Core

public protocol DeleteEventUsecaseProtocol {
    func execute(event: CalendarEvent) async
}

public final class DeleteEventUsecase<Repository: SwiftDataRepositoryProtocol>: WidgetReloadProtocol, DeleteEventUsecaseProtocol where Repository.T == CalendarEvent{
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(event: CalendarEvent) async {
        await repository.deleteData(data: event)
        NotificationCenterService.reloadMoive.post()
        reloadWidget()
        print("Event Delete: \(event.title)")
    }
}

