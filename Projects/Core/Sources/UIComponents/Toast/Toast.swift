//
//  ToastView.swift
//  Core
//
//  Created by 윤제 on 11/19/24.
//

import UIKit

public final class Toast {
    
    public enum postion {
        case top
        case bottom
    }
    
    /// 지속시간 (second)
    public enum Duration {
        case short
        case long
        case custom(duration: Double)
        
        public func toTimeInterval() -> TimeInterval {
            let result: TimeInterval
            switch self {
            case .short:                    result = 2.0
            case .long:                     result = 3.5
            case .custom(let duration):     result = duration
            }
            return result
        }
    }
}

extension Toast {
        
        public static func show(
            message: String,
            duration: Duration = .short,
            position: postion = .bottom
        ) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let toastView = ToastView(frame: .zero, message: message)
            window?.addSubview(toastView)
            
            switch position {
            case .top:
                toastView.pin
                    .top(16)
                    .hCenter()
            case .bottom:
                toastView.pin
                    .bottom(16)
                    .hCenter()
            }
            
            toastView.alpha = 0
            UIView.animate(withDuration: duration.toTimeInterval()) {
                toastView.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: duration.toTimeInterval(), delay: Duration.custom(duration: 0.1).toTimeInterval(), options: .curveEaseOut) {
                    toastView.alpha = 0
                } completion: { _ in
                    toastView.removeFromSuperview()
                }
            }
        }
}
