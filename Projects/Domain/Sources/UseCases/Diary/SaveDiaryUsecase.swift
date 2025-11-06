//
//  SaveDiaryUsecase.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import Core

public protocol SaveDiaryUsecaseProtocol {
    func execute(diary: Diary) async
}

public final class SaveDiaryUsecase<Repository: SwiftDataRepositoryProtocol>: SaveDiaryUsecaseProtocol where Repository.T == Diary {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(diary: Diary) async {
        await repository.insertData(data: diary)
    }
}


