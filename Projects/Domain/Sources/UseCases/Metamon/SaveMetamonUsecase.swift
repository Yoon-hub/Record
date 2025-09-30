//
//  SaveMetamonUsecase.swift
//  Domain
//
//  Created by 윤제 on 9/30/25.
//

import Foundation

public protocol SaveMetamonUsecaseProtocol {
    func execute(metamon: Metamon) async
}

public final class SaveMetamonUsecase<Repository: SwiftDataRepositoryProtocol>: SaveMetamonUsecaseProtocol where Repository.T == Metamon {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(metamon: Metamon) async {
        await repository.insertData(data: metamon)
        print("Metamon Save: \(metamon.metamonItem.rawValue) - \(metamon.point) points")
    }
}

