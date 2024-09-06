//
//  FetchMovieMockUsecase.swift
//  App
//
//  Created by 윤제 on 9/6/24.
//

import Foundation

import Domain

final class FetchMovieMockUsecase: FetchMovieUsecaseProtocol {
    func execute() async -> [Movie] {
        return [
            MovieBuilder()
                .build(),
            MovieBuilder()
                .build()
        ]
    }
}
