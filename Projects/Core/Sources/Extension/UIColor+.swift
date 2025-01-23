//
//  UIColor+.swift
//  Core
//
//  Created by 윤제 on 7/12/24.
//

import UIKit

import Design

extension UIColor {
    public static var recordColor: UIColor {
        Theme.theme
    }
    
    public var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return "#000000"
        }

        let r = Int(red * 255.0)
        let g = Int(green * 255.0)
        let b = Int(blue * 255.0)
        let a = Int(alpha * 255.0)

        if a < 255 {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
}

public extension String {
    func toUIColor() -> UIColor? {
        var cleanedHexString = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // "#"가 있으면 제거
        if cleanedHexString.hasPrefix("#") {
            cleanedHexString.remove(at: cleanedHexString.startIndex)
        }

        // RGB 또는 RGBA 형식 확인
        let length = cleanedHexString.count
        guard length == 6 || length == 8 else {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHexString).scanHexInt64(&rgbValue)

        if length == 6 {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: 1.0
            )
        } else if length == 8 {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0
            )
        } else {
            return nil
        }
    }
}
