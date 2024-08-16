//
//  RestDayDTO.swift
//  Data
//
//  Created by 윤제 on 8/14/24.
//

import Foundation

import Core
import Domain

// MARK: - RESTDayDTO
public struct RESTDayDTO: Decodable {
    public let response: Response
    
    public struct Response: Codable {
        public let header: Header
        public let body: Body
        
        public struct Header: Codable {
            let resultCode, resultMsg: String
        }
        
        public struct Body: Codable {
            public let items: Items
            public let numOfRows, pageNo, totalCount: Int
            
            public struct Items: Codable {
                public let item: [Item]
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    if let singleItem = try? container.decode(Item.self, forKey: .item) {
                        self.item = [singleItem]
                    } else if let itemArray = try? container.decode([Item].self, forKey: .item) {
                        self.item = itemArray
                    } else {
                        self.item = []
                    }
                }
                
                public struct Item: Codable {
                    public let dateKind, dateName, isHoliday: String
                    public let locdate, seq: Int
                }
            }
        }
    }
}

extension RESTDayDTO {
    func toDomain() -> [RestDay] {
        response.body.items.item.map { item in
            RestDay(
                dateName: item.dateName,
                dateKind: item.dateKind,
                date: item.locdate.toDate() ?? Date())
        }
    }
}
