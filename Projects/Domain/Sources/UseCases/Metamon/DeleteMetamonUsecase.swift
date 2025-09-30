//
//  DeleteMetamonUsecase.swift
//  Domain
//
//  Created by 윤제 on 9/30/25.
//

import Foundation

import Core

public protocol DeleteMetamonUsecaseProtocol {
    func execute(metamon: Metamon) async
}

public final class DeleteMetamonUsecase<Repository: SwiftDataRepositoryProtocol>: DeleteMetamonUsecaseProtocol where Repository.T == Metamon {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(metamon: Metamon) async {
        await repository.deleteData(data: metamon)
        print("Metamon Delete: \(metamon.metamonItem.rawValue) - \(metamon.point) points")
    }
}

