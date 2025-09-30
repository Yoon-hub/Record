//
//  UpdateMetamonUsecase.swift
//  Domain
//
//  Created by 윤제 on 9/30/25.
//

import Foundation

import Core

public protocol UpdateMetamonUsecaseProtocol {
    func execute(metamon: Metamon) async
}

public final class UpdateMetamonUsecase<Repository: SwiftDataRepositoryProtocol>: UpdateMetamonUsecaseProtocol where Repository.T == Metamon {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(metamon: Metamon) async {
        await repository.insertData(data: metamon)
        print("Metamon Update: \(metamon.metamonItem.rawValue) - \(metamon.point) points")
    }
}

