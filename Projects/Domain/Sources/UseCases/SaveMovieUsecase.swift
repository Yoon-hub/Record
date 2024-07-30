//
//  SaveMovieUsecase.swift
//  Domain
//
//  Created by 윤제 on 7/30/24.
//

import Foundation

public protocol SaveMovieUsecaseProtocol {
    func execute(movie: Movie)
}

public final class SaveMovieUsecase<Repository: SwiftDataRepositoryProtocol>: SaveMovieUsecaseProtocol where Repository.T == Movie {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(movie: Movie) {
        Task {
            await repository.insertData(data: movie)
        }
    }
}

