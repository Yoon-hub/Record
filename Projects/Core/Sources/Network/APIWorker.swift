//
//  APIWorker.swift
//  Core
//
//  Created by 윤제 on 8/14/24.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

open class APIWorker: NSObject {
    
    public func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        parameters: [APIParameter]? = nil,
        encoding: ParameterEncoding? = URLEncoding.default
    ) -> Observable<(HTTPURLResponse, Data)> {
        
        let headers = self.httpHeaders(headers)
        let parameters = self.parameters(parameters)
        
        return AF.rx.request(
            spec.method,
            spec.url,
            parameters: parameters,
            encoding: encoding!,
            headers: headers,
            interceptor: nil
        )
        .validate(statusCode: 200..<300)
        .responseData()
        .debug("API Worker has received data from \"\(spec.url)\"")
    }
}

extension APIWorker {
    
    private func parameters(_ parameters: [APIParameter]?) -> Parameters? {
        guard let kvs = parameters else { return nil }
        var result: [String: Any] = [:]
        
        for kv in kvs {
            result[kv.key] = kv.value
        }
        
        return result.isEmpty ? nil: result
    }
    
    private func httpHeaders(_ headers: [APIHeader]?) -> HTTPHeaders {
        var result: [String: String] = [:]
        guard let headers = headers, !headers.isEmpty else { return HTTPHeaders() }
        
        for header in headers {
            result[header.key] = header.value
        }
        
        return HTTPHeaders(result)
    }
    
}

