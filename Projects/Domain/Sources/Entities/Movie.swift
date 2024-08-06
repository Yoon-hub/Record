//
//  Movie.swift
//  Domain
//
//  Created by 윤제 on 7/23/24.
//

import SwiftData
import UIKit

@Model
final public class Movie {
    @Attribute(.unique) public var id: String?
    public var title: String
    public var content: String
    public var image: [Data]
    public var date: Date
    public var rate: Int
    public var heart: Int
    
    public init(
        title: String,
        content: String,
        image: [Data],
        date: Date,
        rate: Int
    ) {
        self.id = UUID().uuidString
        self.title = title
         self.content = content
        self.image = image
        self.date = date
        self.rate = rate
        self.heart = 0
    }
}
