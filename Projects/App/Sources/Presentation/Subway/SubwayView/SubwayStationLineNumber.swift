//
//  SubwayStationLineNumber.swift
//  App
//
//  Created by 윤제 on 3/14/25.
//

import UIKit

enum SubwayLine: String {
    case line1 = "1001"   // 1호선
    case line2 = "1002"   // 2호선
    case line3 = "1003"   // 3호선
    case line4 = "1004"   // 4호선
    case line5 = "1005"   // 5호선
    case line6 = "1006"   // 6호선
    case line7 = "1007"   // 7호선
    case line8 = "1008"   // 8호선
    case line9 = "1009"   // 9호선
    case chungang = "1061" // 중앙선
    case gyeonguiJungang = "1063" // 경의중앙선
    case airportRail = "1065" // 공항철도
    case gyeongchun = "1067" // 경춘선
    case bundang = "1075" // 분당선
    case sinbundang = "1077" // 신분당선
    case uisinseol = "1092" // 우이신설선
    case seohae = "1093" // 서해선
    case gyeonggang = "1081" // 경강선
    case gtxA = "1032" // GTX-A선

    // 호선 이름을 반환하는 computed property
    var name: String {
        switch self {
        case .line1: return "1"
        case .line2: return "2"
        case .line3: return "3"
        case .line4: return "4"
        case .line5: return "5"
        case .line6: return "6"
        case .line7: return "7"
        case .line8: return "8"
        case .line9: return "9"
        case .chungang: return "중"
        case .gyeonguiJungang: return "경"
        case .airportRail: return "공"
        case .gyeongchun: return "경"
        case .bundang: return "분"
        case .sinbundang: return "신"
        case .uisinseol: return "우"
        case .seohae: return "서"
        case .gyeonggang: return "경"
        case .gtxA: return "G"
        }
    }

    // 각 호선에 맞는 색상 반환
    var color: UIColor {
        switch self {
        case .line1: return UIColor(hex: "#0033A0")   // 1호선: 파란색
        case .line2: return UIColor(hex: "#008E31")   // 2호선: 초록색
        case .line3: return UIColor(hex: "#FBB03B")   // 3호선: 주황색
        case .line4: return UIColor(hex: "#0099C6")   // 4호선: 파란색
        case .line5: return UIColor(hex: "#7A4B8E")   // 5호선: 보라색
        case .line6: return UIColor(hex: "#9E1B32")   // 6호선: 갈색
        case .line7: return UIColor(hex: "#009C92")   // 7호선: 청록색
        case .line8: return UIColor(hex: "#9B0062")   // 8호선: 자홍색
        case .line9: return UIColor(hex: "#F1C500")   // 9호선: 노란색
        case .chungang: return UIColor(hex: "#777777") // 중앙선: 회색
        case .gyeonguiJungang: return UIColor(hex: "#999999") // 경의중앙선: 연회색
        case .airportRail: return UIColor(hex: "#00A3E0") // 공항철도: 연한 파란색
        case .gyeongchun: return UIColor(hex: "#006F58") // 경춘선: 청록색
        case .bundang: return UIColor(hex: "#E7A9F4") // 분당선: 연보라색
        case .sinbundang: return UIColor(hex: "#F14B4B") // 신분당선: 빨간색
        case .uisinseol: return UIColor(hex: "#7E3C56") // 우이신설선: 녹색
        case .seohae: return UIColor(hex: "#005DAA") // 서해선: 파란색
        case .gyeonggang: return UIColor(hex: "#64A12D") // 경강선: 초록색
        case .gtxA: return UIColor(hex: "#002A5C") // GTX-A선: 다크 블루
        }
    }
}

// UIColor extension to handle hex strings
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
