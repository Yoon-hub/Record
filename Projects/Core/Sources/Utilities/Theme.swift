//
//  Theme.swift
//  Core
//
//  Created by 윤제 on 1/22/25.
//

import UIKit

import Design

final public class Theme {
   static public var theme: UIColor {
        let theme = UserDefaultsWrapper.theme
        
        if theme.isEmpty {
            return DesignAsset.record.color
        } else {
            return theme.toUIColor() ?? DesignAsset.record.color
        }
    }
}
