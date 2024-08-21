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
    func toEventAdd(vc: UIViewController)
}

final class CalendarNavigator: CalendarNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toEventAdd(vc: UIViewController) {
        let eventAddView = EventAddViewControllerWrapper().viewController
        vc.present(eventAddView, animated: true)
    }
}

