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

final public class MovieBuilder {
    private var title: String = ""
    private var content: String = ""
    private var image: [Data] = []
    private var date: Date = Date()
    private var rate: Int = 0
    
    public init() { }
    
    public func setTitle(_ title: String) -> MovieBuilder {
        self.title = title
        return self
    }
    
    public func setContent(_ content: String) -> MovieBuilder {
        self.content = content
        return self
    }
    
    public func setImage(_ image: [Data]) -> MovieBuilder {
        self.image = image
        return self
    }
    
    public func setDate(_ date: Date) -> MovieBuilder {
        self.date = date
        return self
    }
    
    public func setRate(_ rate: Int) -> MovieBuilder {
        self.rate = rate
        return self
    }
    
    public func build() -> Movie {
        return Movie(
            title: title,
            content: content,
            image: image,
            date: date,
            rate: rate
        )
    }
}
