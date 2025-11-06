//
//  Diary.swift
//  Domain
//
//  Created by 윤제 on 1/8/25.
//

import SwiftData
import UIKit

@Model
final public class Diary {
    
    @Attribute(.unique) public var id: String
    public var content: String
    public var date: Date
    
    public init(
        id: String? = nil,
        content: String,
        date: Date
    ) {
        self.id = id ?? UUID().uuidString
        self.content = content
        self.date = date
    }
}


