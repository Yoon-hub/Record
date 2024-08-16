//
//  RestDayRepositoryProtocol.swift
//  Domain
//
//  Created by 윤제 on 8/16/24.
//

import Foundation

import RxSwift

public protocol RestDayRepositoryProtocol {
    func fetchRestDay(year: String, month: String) -> Observable<[RestDay]?>
}
