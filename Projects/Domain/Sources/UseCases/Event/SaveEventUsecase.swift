//
//  SaveEventUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/23/24.
//

import Foundation
import WidgetKit

import Core

public protocol SaveEventUsecaseProtocol {
    func excecute(event: CalendarEvent) async
}

public final class SaveEventUsecase<Repository: SwiftDataRepositoryProtocol>: WidgetReloadProtocol, SaveEventUsecaseProtocol where Repository.T == CalendarEvent {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func excecute(event: CalendarEvent) async {
        await repository.insertData(data: event)
        reloadWidget()
        print("Event Save: \(event.title)")
    }
}
