//
//  WidgetReloader.swift
//  Core
//
//  Created by 윤제 on 11/11/24.
//

import Foundation
import WidgetKit

public protocol WidgetReloadProtocol {}

extension WidgetReloadProtocol {
    public func reloadWidget() {
        WidgetCenter.shared.reloadAllTimelines()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
