//
//  APISpec.swift
//  Core
//
//  Created by 윤제 on 8/14/24.
//

import Foundation

import Alamofire

public protocol API {
    var spec: APISpec { get }
}

// MARK: API Specification
public struct APISpec {
    public let method: HTTPMethod
    public let url: String
    
    public init(method: HTTPMethod, url: String) {
        self.method = method
        self.url = url
    }
}

// MARK: API Header Protocol
public protocol APIHeader {
    var key: String { get }
    var value: String { get }
}

// MARK: API Prameter Protocol
public protocol APIParameter {
    var key: String { get }
    var value: Any? { get }
}
