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
    public var lastFeedDate: Date?
    
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
        point: Int,
        lastFeedDate: Date? = nil
    ) {
        self.metamonItemRawValue = metamonItem.rawValue
        self.point = point
        self.lastFeedDate = lastFeedDate
    }
    
    /// 오늘 밥을 먹었는지 확인
    public func canFeedToday() -> Bool {
        guard let lastFeed = lastFeedDate else { return true }
        return !Calendar.current.isDateInToday(lastFeed)
    }
    
    /// 밥 먹이기
    public func feed() {
        lastFeedDate = Date()
        point += 100
    }
    
}

public enum MetamonItem: String, CaseIterable {
    case basic = "basic"
    case flower = "flower"
    case crown = "crown"
    case letter = "letter"
    case santa = "santa"
    case chunguma = "chunguma"
    case pikachu = "pikachu"
    case pairi = "pairi"
    case kkobugi = "kkobugi"
    case lake = "lake"
    
    public var metamonImage: UIImage? {
        switch self {
        case .basic: return DesignAsset.metamon.image
        case .crown: return DesignAsset.metamonCrwon.image
        case .letter: return DesignAsset.metamonLetter.image
        case .santa: return DesignAsset.metamonSanta.image
        case .pikachu: return DesignAsset.metamonPikachu.image
        case .pairi: return DesignAsset.metamonPairi.image
        case .kkobugi: return DesignAsset.metamonKkobugi.image
        case .chunguma: return DesignAsset.metamonChunguma.image
        case .lake: return DesignAsset.metamonLake.image
        case .flower: return DesignAsset.metamonFlower.image
        }
    }
    
    public var itemImage: UIImage? {
        switch self {
        case .basic: return DesignAsset.noItem.image
        case .crown: return DesignAsset.crwon.image
        case .letter: return DesignAsset.letter.image
        case .santa: return DesignAsset.santa.image
        case .pikachu: return DesignAsset.pikachu.image
        case .pairi: return DesignAsset.pairi.image
        case .kkobugi: return DesignAsset.kkobugi.image
        case .chunguma: return DesignAsset.chunguma.image
        case .lake: return DesignAsset.lake.image
        case .flower: return DesignAsset.flower.image
        }
    }
    
    public var price: Int {
        switch self {
        case .basic: return 1000
        case .crown: return 1000
        case .letter: return 300
        case .santa: return 1000
        case .pikachu: return 2000
        case .pairi: return 2000
        case .kkobugi: return 2000
        case .chunguma: return 1100
        case .lake: return 2500
        case .flower: return 50
        }
    }
}
