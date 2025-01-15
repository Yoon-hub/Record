//
//  KakaoShareViewController.swift
//  App
//
//  Created by 윤제 on 1/15/25.
//

import UIKit

import Core

import FloatingBottomSheet

final class KakaoShareViewController: BaseViewController<KakaoShareReactor, KakaoShareView> {
    
}

// MARK: - FloatingBottomSheet
extension KakaoShareViewController: FloatingBottomSheetPresentable {
    var bottomSheetScrollable: UIScrollView? { UIScrollView() }
    
    var allowsDrag: Bool { false }
      
    var bottomSheetHeight: CGFloat { 440 }
}
