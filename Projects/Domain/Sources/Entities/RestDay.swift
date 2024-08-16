//
//  RestDay.swift
//  Domain
//
//  Created by 윤제 on 8/14/24.
//

import SwiftData
import UIKit

@Model
final public class RestDay {
    
    enum DateKind: String {
        case holidy = "01"
        case anniversary = "02"
    }
    
    public var dateName: String
    public var dateKind: String
    public var date: Date
    
    public init(
        dateName: String,
        dateKind: String,
        date: Date
    ) {
        self.dateName = dateName
        self.date = date
        self.dateKind = dateKind
    }
}
