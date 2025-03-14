//
//  SubwayAPIs.swift
//  Data
//
//  Created by 윤제 on 3/12/25.
//

import Foundation

import Core

public enum SubwayAPIs: API {
    
    var serviceKey: String {
        "476345456163737634304e6a48446b"
    }
    
    case fetchSubwayArrivalInfo(String)
    
    public var spec: APISpec {
        switch self {
        case .fetchSubwayArrivalInfo(let station):
            return APISpec(method: .get, url: "\(APIHost.subwayBaseURL)/\(serviceKey)/json/realtimeStationArrival/0/4/\(station)")
        }
    }
}
