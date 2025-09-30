//
//  FetchMetamonUsecase.swift
//  Domain
//
//  Created by 윤제 on 9/30/25.
//

import Foundation

import Core

public protocol FetchMetamonUsecaseProtocol {
    func execute() async -> [Metamon]
}

public final class FetchMetamonUsecase<Repository: SwiftDataRepositoryProtocol>: FetchMetamonUsecaseProtocol where Repository.T == Metamon {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute() async -> [Metamon] {
        do {
            let data = try await repository.fetchData()
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

