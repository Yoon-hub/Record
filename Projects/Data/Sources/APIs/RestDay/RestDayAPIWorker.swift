//
//  RestAPIWorker.swift
//  Data
//
//  Created by 윤제 on 8/14/24.
//

import Foundation

import Core

import Alamofire
import RxSwift

public extension RestDayAPIs {
    final class Worker: APIWorker {}
}

public extension RestDayAPIs.Worker {
    func fetchRestDay(year: String, month: String) -> Single<RESTDayDTO?> {
        let spec = RestDayAPIs.fetchRestDay(year, month).spec
        
        return request(spec: spec)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("StatisticsSummary Fetch Result: \(str)")
                }
            }
            .map(RESTDayDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
}
