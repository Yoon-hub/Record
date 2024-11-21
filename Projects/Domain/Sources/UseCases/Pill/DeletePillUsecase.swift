//
//  DeletePillUsecase.swift
//  Domain
//
//  Created by 윤제 on 11/21/24.
//

import Foundation

import Core

public protocol DeletePillUsecaseProtocol {
    func execute(event: Pill) async
}

public final class DeletePillUsecase<Repository: SwiftDataRepositoryProtocol>: DeletePillUsecaseProtocol where Repository.T == Pill {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(event: Pill) async {
        await repository.deleteData(data: event)
        print("Pill Delete: \(event.title)")
    }
}

