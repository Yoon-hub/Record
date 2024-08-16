//
//  RestDayRepository.swift
//  Data
//
//  Created by 윤제 on 8/16/24.
//

import Foundation

import Domain

import RxSwift

public final class RestDayRepository: RestDayRepositoryProtocol {
    
    private let worker = RestDayAPIs.Worker()
    
    public init() {}
}

extension RestDayRepository {
    public func fetchRestDay(year: String, month: String) -> Observable<[RestDay]?> {
        return worker.fetchRestDay(year: year, month: month)
            .map { $0?.toDomain() }
            .asObservable()
    }
}
