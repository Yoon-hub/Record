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
            position: postion = .bottom,
            tapGesture: (() -> Void)? = nil
        ) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let toastView = ToastView(frame: .zero, message: message)
            
            /// 터치 이벤트 추가
            if let tapGesture { toastView.onTap = tapGesture }
            
            window?.addSubview(toastView)
            
            switch position {
            case .top:
                toastView.pin
                    .top(window?.safeAreaInsets.top ?? 0 + 16)
                    .hCenter()
                    .size(CGSize(width: 50, height: 50))
            case .bottom:
                toastView.pin
                    .bottom(window?.safeAreaInsets.bottom ?? 0 + 16)
                    .hCenter()
                    .size(toastView.backgroundView.frame.size)
            }
            
            window?.layoutIfNeeded()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration.toTimeInterval()) {
                /// WithDrauton 1 -> 0 까지 걸리는 시간
                /// delay: 특정 시간 이후에 동작
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    toastView.alpha = 0
                } completion: { _ in
                    toastView.removeFromSuperview()
                }
            }
        }
}
