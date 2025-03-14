//
//  ArriveInfo.swift
//  Data
//
//  Created by 윤제 on 3/14/25.
//

import Foundation

public struct ArriveInfo: Hashable {
    
    /// 이전지하철역ID
    public let statnFid: String
    
    /// 다음 지하철역ID
    public let statnTid: String
    
    /// 지하철역ID
    public let statnId: String
    
    /// 지하철 호선 정보
    public let subWayId: String
    
    /// 도착 시간정보
    public var barvDt: [String]
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(statnFid)
        hasher.combine(statnTid)
        hasher.combine(statnId)
        hasher.combine(subWayId)
    }
    
    public init(statnFid: String, statnTid: String, statnId: String, subWayId: String, barvDt: [String]) {
        self.statnFid = statnFid
        self.statnTid = statnTid
        self.statnId = statnId
        self.subWayId = subWayId
        self.barvDt = barvDt
    }
    
    public static func == (lhs: ArriveInfo, rhs: ArriveInfo) -> Bool {
        return lhs.statnFid == rhs.statnFid &&
               lhs.statnTid == rhs.statnTid &&
               lhs.statnId == rhs.statnId &&
               lhs.subWayId == rhs.subWayId
    }
}
