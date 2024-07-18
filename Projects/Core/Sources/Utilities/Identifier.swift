//
//  Identifier.swift
//  Core
//
//  Created by 윤제 on 7/18/24.
//

import UIKit

public protocol IdentifierProtocol {
    static var identifier: String { get }
}

extension IdentifierProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: IdentifierProtocol {}
