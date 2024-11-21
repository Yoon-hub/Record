//
//  FetchPillUsecase.swift
//  Domain
//
//  Created by 윤제 on 11/21/24.
//

import Foundation

import Core

public protocol FetchPillUsecaseProtocol {
    func execute() async -> [Pill]
}

public final class FetchPillUsecase<Repository: SwiftDataRepositoryProtocol>: FetchPillUsecaseProtocol where Repository.T == Pill {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute() async -> [Pill] {
        do {
            let data = try await repository.fetchData()
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
