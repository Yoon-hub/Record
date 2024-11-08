//
//  WidgetBundle.swift
//  App
//
//  Created by 윤제 on 11/4/24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    
    init() {
        WidgetEventProvider.default.fetchEvent()
    }
    
    var body: some Widget {
        WidgetExtension()
    }
}

