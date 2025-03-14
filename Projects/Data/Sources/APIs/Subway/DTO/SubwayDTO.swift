//
//  SubwayDTO.swift
//  Data
//
//  Created by 윤제 on 3/14/25.
//

import Foundation

// SubwayDTO DTO
public struct SubwayDTO: Codable {
    
    // ErrorMessage DTO
    public struct ErrorMessage: Codable {
        public let status: Int
        public let code: String
        public let message: String
        public let link: String
        public let developerMessage: String
        public let total: Int
    }
    
    // RealtimeArrival DTO
    public struct RealtimeArrival: Codable {
        public let beginRow: Int?
        public let endRow: Int?
        public let curPage: Int?
        public let pageRow: Int?
        public let totalCount: Int
        public let rowNum: Int
        public let selectedCount: Int
        public let subwayId: String
        public let subwayNm: String?
        public let updnLine: String
        public let trainLineNm: String
        public let subwayHeading: String?
        public let statnFid: String
        public let statnTid: String
        public let statnId: String
        public let statnNm: String
        public let trainCo: String?
        public let trnsitCo: String
        public let ordkey: String
        public let subwayList: String
        public let statnList: String
        public let btrainSttus: String
        public let barvlDt: String
        public let btrainNo: String
        public let bstatnId: String
        public let bstatnNm: String
        public let recptnDt: String
        public let arvlMsg2: String
        public let arvlMsg3: String
        public let arvlCd: String
        public let lstcarAt: String
    }
    
    public let errorMessage: ErrorMessage
    public let realtimeArrivalList: [RealtimeArrival]
}
