//
//  CalendarNavigator.swift
//  App
//
//  Created by 윤제 on 8/12/24.
//

import UIKit

import Core
import Domain

protocol CalendarNavigatorProtocol: BaseNavigator {
    
}

final class CalendarNavigator: CalendarNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

}

