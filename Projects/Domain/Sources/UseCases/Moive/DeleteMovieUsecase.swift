//
//  DeleteMovieUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/5/24.
//

import Foundation

import Core

public protocol DeleteMovieUsecaseProtocol {
    func execute(movie: Movie)
}

public final class DeleteMovieUsecase<Repository: SwiftDataRepositoryProtocol>: DeleteMovieUsecaseProtocol where Repository.T == Movie {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(movie: Movie) {
        Task {
            await repository.deleteData(data: movie)
            NotificationCenterService.reloadMoive.post()
        }
    }
}
