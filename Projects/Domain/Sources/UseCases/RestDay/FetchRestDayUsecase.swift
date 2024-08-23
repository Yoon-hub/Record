//
//  FetchRestDayUsecase.swift
//  Domain
//
//  Created by 윤제 on 8/16/24.
//

import Foundation

import RxSwift

public protocol FetchRestDayUsecaseProtocol {
    func excute(year: String, month: String) -> Observable<[RestDay]?>
}

public final class FetchRestDayUsecase: FetchRestDayUsecaseProtocol {
    
    let repository: RestDayRepositoryProtocol
    
    public init(repository: RestDayRepositoryProtocol) {
        self.repository = repository
    }
    
    public func excute(year: String, month: String) -> Observable<[RestDay]?> {
        repository.fetchRestDay(year: year, month: month)
    }
}
