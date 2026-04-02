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
            .flatMap { _, data -> Observable<RESTDayDTO?> in
                let preview = String(data: data, encoding: .utf8)
                do {
                    let dto = try JSONDecoder().decode(RESTDayDTO.self, from: data)
                    let code = dto.response.header.resultCode
                    if code != "00" {
                        RestDayAPILogger.businessFailure(
                            year: year,
                            month: month,
                            resultCode: code,
                            resultMsg: dto.response.header.resultMsg
                        )
                        return Observable.just(nil)
                    }
                    return Observable.just(dto)
                } catch {
                    RestDayAPILogger.decodeFailure(year: year, month: month, error: error, responsePreview: preview)
                    return Observable.just(nil)
                }
            }
            .catch { error in
                RestDayAPILogger.networkFailure(year: year, month: month, error: error)
                return Observable.just(nil)
            }
            .asSingle()
    }
}
