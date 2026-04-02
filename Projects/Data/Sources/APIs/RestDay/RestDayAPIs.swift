//
//  RestDayAPIs.swift
//  Data
//
//  Created by 윤제 on 8/14/24.
//

import Foundation

import Core

public enum RestDayAPIs: API {
    
    var serviceKey: String { "6bc41e4203192f0dbe56c50dfe78f911e2031355ac8949d2a3fe3b15ab5a689f"
    }
    
    case fetchRestDay(String, String)
    
    public var spec: APISpec {
        switch self {
        case .fetchRestDay(let year, let month):
            return APISpec(method: .get, url: "\(APIHost.restDayBaseURL)/getRestDeInfo?serviceKey=\(serviceKey)&solYear=\(year)&solMonth=\(month)&_type=json")
        }
    }
}
