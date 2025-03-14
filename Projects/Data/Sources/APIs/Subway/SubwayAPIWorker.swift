//
//  SubwayAPIWorker.swift
//  Data
//
//  Created by 윤제 on 3/14/25.
//

import Foundation

import Core

import Alamofire
import RxSwift

public extension SubwayAPIs {
    final class Worker: APIWorker {}
}

public extension SubwayAPIs.Worker {
    func fetchSubway(station: String) -> Single<SubwayDTO?> {
        let spec = SubwayAPIs.fetchSubwayArrivalInfo(station).spec
        
        return request(spec: spec)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("StatisticsSummary Fetch Result: \(str)")
                }
            }
            .map(SubwayDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
}
    
