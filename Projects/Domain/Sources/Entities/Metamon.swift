//
//  Metamon.swift
//  Domain
//
//  Created by 윤제 on 9/30/25.
//

import SwiftData
import UIKit

import Design

@Model
final public class Metamon {
    
    private var metamonItemRawValue: String
    public var point: Int
    
    public var metamonItem: MetamonItem {
        get {
            return MetamonItem(rawValue: metamonItemRawValue) ?? .basic
        }
        set {
            metamonItemRawValue = newValue.rawValue
        }
    }
    
    public init(
        metamonItem: MetamonItem,
        point: Int
    ) {
        self.metamonItemRawValue = metamonItem.rawValue
        self.point = point
    }
    
}

public enum MetamonItem: String, CaseIterable {
    case basic = "basic"
    case crown = "crown"
    
    public var image: UIImage? {
        switch self {
        case .basic: return DesignAsset.metamon.image
        case .crown: return DesignAsset.metamonChatBox.image
        }
    }
}
