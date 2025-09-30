//
//  Int+.swift
//  Core
//
//  Created by 윤제 on 8/16/24.
//

import Foundation

public extension Int {
    func toDate() -> Date? {
        let dateString = String(self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: dateString)
    }
    
    func addComma() -> String {
         let numberFormatter = NumberFormatter()
         numberFormatter.numberStyle = .decimal
         return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
     }
}
