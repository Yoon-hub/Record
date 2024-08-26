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
        DesignAsset.record.color
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
