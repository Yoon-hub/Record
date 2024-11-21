//
//  Pill.swift
//  Domain
//
//  Created by 윤제 on 11/21/24.
//

import SwiftData
import UIKit

@Model
final public class Pill {
    public var title: String
    public var tiem: String
    public var use: Bool
    
    init(
        title: String,
        tiem: String,
        use: Bool
    ) {
        self.title = title
        self.tiem = tiem
        self.use = use
    }
}
