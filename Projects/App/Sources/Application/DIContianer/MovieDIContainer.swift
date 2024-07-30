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
            repository: makeSwiftDataRepository()
        )
    }
    
    private func makeFetchMovieUsecase() -> FetchMovieUsecaseProtocol {
        FetchMovieUsecase(
            repository: makeSwiftDataRepository()
        )
    }
    
    // MARK: - Make Repository
    private func makeSwiftDataRepository<Movie: PersistentModel>() -> SwiftDataRepository<Movie> {
        return SwiftDataRepository<Movie>()
    }
    
    func registerDependencies() {
        container.register(type: SaveMovieUsecaseProtocol.self) { _ in
            self.makeSaveMovieUsecase()
        }
        
        container.register(type: FetchMovieUsecaseProtocol.self) { _ in
            self.makeFetchMovieUsecase()
        }
    }
}
