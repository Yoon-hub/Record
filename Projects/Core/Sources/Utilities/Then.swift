//
//  Then.swift
//  Core
//
//  Created by 윤제 on 7/18/24.
//

import UIKit

public protocol Then {}

extension Then where Self: AnyObject {
    
    @inlinable
    public func then(
        _ block: (Self) throws -> Void
    ) rethrows -> Self {
      try block(self)
      return self
    }
}

extension UIView: Then {}
