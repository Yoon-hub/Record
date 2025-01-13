//
//  UIViewController+Delay.swift
//  Core
//
//  Created by 윤제 on 1/9/25.
//

import UIKit

public func delay(_ delay: Double, closure: @escaping () -> Void ) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        closure()
    }
}

