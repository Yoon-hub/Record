//
//  FetchEventUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/28/24.
//

import Foundation
import WidgetKit

public protocol FetchEventUsecaseProtocol {
    func execute() async -> [CalendarEvent]
}

public final class FetchEventUsecase<Repository: SwiftDataRepositoryProtocol>: WidgetReloadProtocol, FetchEventUsecaseProtocol where Repository.T == CalendarEvent {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute() async -> [CalendarEvent] {
        do {
            let data = try await repository.fetchData()
            reloadWidget()
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
