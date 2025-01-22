//
//  KakaoShareViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 1/15/25.
//

import UIKit

import Core
import Domain

final class KakaoShareViewControllerWrapper: BaseWrapper {
    
    typealias R = KakaoShareReactor
    typealias V = KakaoShareViewController
    typealias C = KakaoShareView
    
    let kakaoEvent: CalendarEvent
    
    init(kakaoEvent: CalendarEvent) {
        self.kakaoEvent = kakaoEvent
    }
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return KakaoShareViewController(
            contentView: view,
            reactor: reactor
        )
    }
    
    func makeReactor() -> R {
        return KakaoShareReactor(kakaoEvent: kakaoEvent)
    }
    
    func makeView() -> C {
        return KakaoShareView()
    }

}
