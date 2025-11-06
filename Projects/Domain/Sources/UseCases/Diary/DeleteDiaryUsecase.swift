//
//  DeleteDiaryUsecase.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

import Core

public protocol DeleteDiaryUsecaseProtocol {
    func execute(diary: Diary) async
}

public final class DeleteDiaryUsecase<Repository: SwiftDataRepositoryProtocol>: DeleteDiaryUsecaseProtocol where Repository.T == Diary {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(diary: Diary) async {
        await repository.deleteData(data: diary)
    }
}


