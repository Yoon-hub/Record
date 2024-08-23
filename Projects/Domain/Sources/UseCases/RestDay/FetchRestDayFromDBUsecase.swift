//
//  FetchRestDayFromDBUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/16/24.
//

import Foundation

public protocol FetchRestDayFromDBUsecaserotocol {
    func execute() async -> [RestDay]
}

public final class FetchRestDayFromDBUsecase<Repository: SwiftDataRepositoryProtocol>: FetchRestDayFromDBUsecaserotocol where Repository.T == RestDay {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute() async -> [RestDay] {
        do {
            let data = try await repository.fetchData()
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

