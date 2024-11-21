//
//  SavePillUsecase.swift
//  Domain
//
//  Created by 윤제 on 11/21/24.
//

import Foundation

public protocol SavePillUsecaseProtocol {
    func excecute(event: Pill) async
}

public final class SavePillUsecase<Repository: SwiftDataRepositoryProtocol>: SavePillUsecaseProtocol where Repository.T == Pill {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func excecute(event: Pill) async {
        await repository.insertData(data: event)
        print("Pill Save: \(event.title)")
    }
}
