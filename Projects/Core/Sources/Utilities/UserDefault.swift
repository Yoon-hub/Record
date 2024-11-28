//
//  UserDefault.swift
//  Core
//
//  Created by 윤제 on 8/16/24.
//

import Foundation

@propertyWrapper
public struct UserDefault {
    
    public let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public var wrappedValue: String {
        get {
            UserDefaults.standard.string(forKey: key) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

public struct UserDefaultsWrapper {
    @UserDefault(key: "lastSelectedColor") public static var color
    @UserDefault(key: "sortedBy") public static var sorted
    @UserDefault(key: "firstWeekday") public static var firstWeekday
}
