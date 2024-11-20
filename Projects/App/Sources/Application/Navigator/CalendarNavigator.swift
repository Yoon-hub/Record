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
    func toEventAdd(vc: UIViewController, seletedDate: Date, reloadTableView: @escaping () -> Void)
    func toEventFix(vc: UIViewController, seletedDate: Date, currentEvent: CalendarEvent, reloadTableView: @escaping () -> Void)
    func toSetting()
}

final class CalendarNavigator: CalendarNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toEventAdd(vc: UIViewController, seletedDate: Date, reloadTableView: @escaping () -> Void) {
        let eventAddView = EventAddViewControllerWrapper(seletedDate: seletedDate, reloadTableView: reloadTableView).viewController
        vc.present(eventAddView, animated: true)
    }
    
    func toEventFix(vc: UIViewController, seletedDate: Date, currentEvent: CalendarEvent ,reloadTableView: @escaping () -> Void) {
        let eventFixView = EventFixViewControllerWrapper(seletedDate: seletedDate, currentEvent: currentEvent, reloadTableView: reloadTableView).viewController
        vc.present(eventFixView, animated: true)
    }
    
    func toSetting() {
        let settingView = SettingViewControllerWrapper().viewController
        self.navigationController.pushViewController(settingView, animated: true)
    }
}

