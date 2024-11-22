//
//  SaveMovieUsecase.swift
//  Domain
//
//  Created by 윤제 on 7/30/24.
//

import Foundation

import Core

public protocol SaveMovieUsecaseProtocol {
    func execute(movie: Movie) async
}

public final class SaveMovieUsecase<Repository: SwiftDataRepositoryProtocol>: SaveMovieUsecaseProtocol where Repository.T == Movie {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(movie: Movie) async {
        await repository.insertData(data: movie)
        NotificationCenterService.reloadMoive.post()
    }
}
