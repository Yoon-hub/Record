//
//  SaveRestDayUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/14/24.
//

public protocol SaveRestUsecaseProtocol {
    func  execute(restDay: RestDay)
}

public final class SaveRestDayUsecase<Repository: SwiftDataRepositoryProtocol>: SaveRestUsecaseProtocol where Repository.T == RestDay {
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(restDay: RestDay) {
        Task {
            await repository.insertData(data: restDay)
        }
    }
}


