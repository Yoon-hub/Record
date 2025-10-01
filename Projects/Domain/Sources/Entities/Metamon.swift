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
    case letter = "letter"
    case santa = "santa"
    case pikachu = "pikachu"
    
    public var metamonImage: UIImage? {
        switch self {
        case .basic: return DesignAsset.metamon.image
        case .crown: return DesignAsset.metamonCrwon.image
        case .letter: return DesignAsset.metamonLetter.image
        case .santa: return DesignAsset.metamonSanta.image
        case .pikachu: return DesignAsset.metamonPikachu.image
        }
    }
    
    public var itemImage: UIImage? {
        switch self {
        case .basic: return DesignAsset.noItem.image
        case .crown: return DesignAsset.crwon.image
        case .letter: return DesignAsset.letter.image
        case .santa: return DesignAsset.santa.image
        case .pikachu: return DesignAsset.pikachu.image
        }
    }
    
    public var price: Int {
        switch self {
        case .basic: return 1000
        case .crown: return 1000
        case .letter: return 1000
            
        case .santa: return 1000
        case .pikachu: return 2000
        }
    }
}
