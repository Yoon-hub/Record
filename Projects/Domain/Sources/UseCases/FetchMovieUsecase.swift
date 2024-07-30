//
//  FetchMovieUsecase.swift
//  Domain
//
//  Created by 윤제 on 7/30/24.
//

import Foundation

public protocol FetchMovieUsecaseProtocol {
    func execute() async -> [Movie]
}

public final class FetchMovieUsecase<Repository: SwiftDataRepositoryProtocol>: FetchMovieUsecaseProtocol where Repository.T == Movie {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute() async -> [Movie] {
        do {
            let data = try await repository.fetchData()
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
