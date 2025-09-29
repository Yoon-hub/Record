//
//  EmoticonProvider.swift
//  Core
//
//  Created by 윤제 on 12/19/24.
//

import UIKit
import Design

/// 이모지 리스트를 제공하는 유틸리티 클래스
public final class EmoticonProvider {
    
    /// 기본 이모지 리스트
    public static let defaultEmoticonList: [UIImage] = [
        DesignAsset.nomalEmo1.image,
        DesignAsset.nomalEmo2.image,
        DesignAsset.nomalEmo3.image,
        DesignAsset.nomalEmo4.image,
        DesignAsset.nomalEmo5.image,
        DesignAsset.nomalEmo6.image,
        DesignAsset.nomalEmo7.image,
        DesignAsset.nomalEmo8.image,
        DesignAsset.nomalEmo9.image,
        DesignAsset.nomalEmo10.image,
        DesignAsset.nomalEmo11.image,
        DesignAsset.nomalEmo12.image,
        DesignAsset.nomalEmo13.image,
        DesignAsset.nomalEmo14.image,
        DesignAsset.nomalEmo15.image,
        DesignAsset.nomalEmo16.image,
        DesignAsset.nomalEmo17.image,
        DesignAsset.nomalEmo18.image,
        DesignAsset.nomalEmo19.image,
        DesignAsset.nomalEmo20.image,
        DesignAsset.nomalEmo21.image,
        DesignAsset.nomalEmo22.image,
        DesignAsset.nomalEmo23.image,
        DesignAsset.nomalEmo24.image,
        DesignAsset.nomalEmo25.image,
        DesignAsset.nomalEmo26.image,
        DesignAsset.nomalEmo27.image,
        DesignAsset.nomalEmo28.image,
        DesignAsset.nomalEmo29.image,
        DesignAsset.normalEmo30.image,
        DesignAsset.normalEmo31.image,
        DesignAsset.normalEmo32.image,
        DesignAsset.normalEmo33.image,
        DesignAsset.normalEmo34.image,
        DesignAsset.normalEmo35.image,
        DesignAsset.normalEmo36.image,
        DesignAsset.normalEmo37.image,
        DesignAsset.normalEmo38.image,
        DesignAsset.normalEmo39.image,
        DesignAsset.normalEmo40.image,
        DesignAsset.normalEmo41.image,
        DesignAsset.normalEmo42.image,
        DesignAsset.normalEmo43.image,
        DesignAsset.normalEmo44.image,
        DesignAsset.normalEmo45.image,
        DesignAsset.normalEmo46.image,
        DesignAsset.normalEmo47.image,
        DesignAsset.normalEmo48.image,
        DesignAsset.normalEmo49.image,
        DesignAsset.normalEmo50.image,
        DesignAsset.normalEmo51.image,
        DesignAsset.normalEmo52.image,
        DesignAsset.normalEmo53.image,
    ]
    
    /// 랜덤 이모지를 반환합니다
    /// - Returns: 랜덤하게 선택된 이모지 이미지
    public static func randomEmoticon() -> UIImage? {
        return defaultEmoticonList.randomElement()
    }
    
    /// 특정 인덱스의 이모지를 반환합니다
    /// - Parameter index: 이모지 인덱스 (0부터 시작)
    /// - Returns: 해당 인덱스의 이모지 이미지, 범위를 벗어나면 nil
    public static func emoticon(at index: Int) -> UIImage? {
        guard index >= 0 && index < defaultEmoticonList.count else { return nil }
        return defaultEmoticonList[index]
    }
    
    /// 이모지 리스트의 총 개수를 반환합니다
    public static var emoticonCount: Int {
        return defaultEmoticonList.count
    }
    
    /// 중복되지 않는 랜덤 이모지들을 반환합니다
    /// - Parameter count: 필요한 이모지 개수
    /// - Returns: 중복되지 않는 랜덤 이모지 배열
    public static func randomUniqueEmoticons(count: Int) -> [UIImage] {
        var availableEmoticons = defaultEmoticonList
        var selectedEmoticons: [UIImage] = []
        
        let actualCount = min(count, availableEmoticons.count)
        
        for _ in 0..<actualCount {
            let randomIndex = Int.random(in: 0..<availableEmoticons.count)
            let selectedEmoticon = availableEmoticons.remove(at: randomIndex)
            selectedEmoticons.append(selectedEmoticon)
        }
        
        return selectedEmoticons
    }
}
