//
//  PillViewController.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import UIKit

import Core

import FloatingBottomSheet

final class PillViewController: BaseViewController<PillReactor, PillView> {

}

//MARK: - FloatingBottomSheet
extension PillViewController: FloatingBottomSheetPresentable {
    var bottomSheetScrollable: UIScrollView? { UIScrollView() }
      
    var bottomSheetHeight: CGFloat { 440 }
}
