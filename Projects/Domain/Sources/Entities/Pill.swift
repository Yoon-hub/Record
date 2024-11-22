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
    
    @Attribute(.unique) public var id: String
    public var title: String
    public var time: String
    public var use: Bool
    
    public init(
        title: String,
        time: String,
        use: Bool
    ) {
        self.id = UUID().uuidString
        self.title = title
        self.time = time
        self.use = use
    }
}
