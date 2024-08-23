//
//  DeleteRestDayUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/16/24.
//

import Foundation

import Core

public protocol DeleteRestDayUsecaseProtocol {
    func execute()
}

public final class DeleteRestDayUsecase<Repository: SwiftDataRepositoryProtocol>: DeleteRestDayUsecaseProtocol where Repository.T == RestDay {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute() {
        Task {
            await repository.deleteAllData()
        }
    }
}

