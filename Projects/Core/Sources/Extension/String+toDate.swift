//
//  String+toDate.swift
//  Core
//
//  Created by 윤제 on 1/14/25.
//

import Foundation

extension String {
    /// String을 주어진 포맷으로 Date로 변환
    public func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 Locale 설정
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
