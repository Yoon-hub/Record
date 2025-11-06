//
//  FetchDiaryUsecase.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import Foundation

public protocol FetchDiaryUsecaseProtocol {
    func execute() async -> [Diary]
}

public final class FetchDiaryUsecase<Repository: SwiftDataRepositoryProtocol>: FetchDiaryUsecaseProtocol where Repository.T == Diary {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute() async -> [Diary] {
        do {
            let data = try await repository.fetchData()
            return data.sorted { $0.date < $1.date } // 오래된 순 정렬 (맨 아래에 최신 일기)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}


