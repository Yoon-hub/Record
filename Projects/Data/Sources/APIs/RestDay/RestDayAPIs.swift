//
//  RestDayAPIs.swift
//  Data
//
//  Created by 윤제 on 8/14/24.
//

import Foundation

import Core

public enum RestDayAPIs: API {
    
    var serviceKey: String { "AU2BzWw7GCVRxC8DGbeMWhrP%2BiuWG7DQnFc2ulnFr9OT0A0HE5%2BY3j9fuSOxcVoHHGMnP7%2BMpLegEtfd5Fs5bw%3D%3D"
    }
    
    case fetchRestDay(String, String)
    
    public var spec: APISpec {
        switch self {
        case .fetchRestDay(let year, let month):
            return APISpec(method: .get, url: "\(APIHost.restDayBaseURL)/getRestDeInfo?serviceKey=\(serviceKey)&solYear=\(year)&solMonth=\(month)&_type=json")
        }
    }
}
