//
//  NotificationCenterService.swift
//  Core
//
//  Created by 윤제 on 7/31/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol NotificationCenterHandler {
    var name: Notification.Name { get }
}

public extension NotificationCenterHandler {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(name).map {$0.object}
    }

    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: nil)
    }
}

public enum NotificationCenterService: NotificationCenterHandler {
    case reloadMoive
    case reloadCalendar

    public var name: Notification.Name {
        switch self {
        case .reloadMoive:
            return Notification.Name("NotificationCenterService.reloadMoive")
        case .reloadCalendar:
            return Notification.Name("NotificationCenterService.reloadCalendar")
        }
    }
}
