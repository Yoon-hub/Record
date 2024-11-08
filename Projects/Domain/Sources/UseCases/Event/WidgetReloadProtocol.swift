//
//  WidgetReloadProtocol.swift
//  Domain
//
//  Created by 윤제 on 11/8/24.
//

import Foundation
import WidgetKit

protocol WidgetReloadProtocol {}

extension WidgetReloadProtocol {
    func reloadWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "tomatoWidget")
    }
}
