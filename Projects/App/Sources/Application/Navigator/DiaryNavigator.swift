//
//  DiaryNavigator.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Core
import Domain

protocol DiaryNavigatorProtocol: BaseNavigator {
    // 필요시 네비게이션 메서드 추가
    var navigationController: UINavigationController { get set }
}

final class DiaryNavigator: DiaryNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}


