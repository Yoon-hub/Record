//
//  MovieDIContainer.swift
//  App
//
//  Created by 윤제 on 7/30/24.
//

import UIKit
import SwiftData

import Core
import Data
import Domain

final class MovieDIContainer: BaseContainer {
    
    private func makeSaveMovieUsecase() -> SaveMovieUsecaseProtocol {
        SaveMovieUsecase(
            repository: self.repository
        )
    }
    
    private func makeFetchMovieUsecase() -> FetchMovieUsecaseProtocol {
        FetchMovieUsecase(
            repository: self.repository
        )
    }
    
    private func makeDeleteMovieUsecase() -> DeleteMovieUsecaseProtocol {
        DeleteMovieUsecase(
            repository: self.repository
        )
    }
    
    private var repository = {
        SwiftDataRepository<Movie>()
    }()
    
    // MARK: - Make Repository
    
    func registerDependencies() {
        container.register(type: SaveMovieUsecaseProtocol.self) { _ in
            self.makeSaveMovieUsecase()
        }
        
        container.register(type: FetchMovieUsecaseProtocol.self) { _ in
            self.makeFetchMovieUsecase()
        }
        
        container.register(type: DeleteMovieUsecaseProtocol.self) { _ in
            self.makeDeleteMovieUsecase()
        }
    }
}
