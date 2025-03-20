//
//  APIHost.swift
//  Data
//
//  Created by 윤제 on 8/14/24.
//

import Foundation

public enum APIHost {
    
    /// 공휴일 정보
    static let restDayBaseURL = "https://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService"
    
    /// 지하철 도착 정보
    static let subwayBaseURL = "http://swopenAPI.seoul.go.kr/api/subway"
}
