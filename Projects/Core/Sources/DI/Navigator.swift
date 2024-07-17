//
//  Navigator.swift
//  Core
//
//  Created by 윤제 on 7/17/24.
//

import Foundation

@propertyWrapper
public struct Navigator<V> {
    
    public let identifier: InjectIdentifier<V>
    
    public init() {
        self.identifier = .by(type: V.self)
    }
    
    public lazy var wrappedValue: V = {
        let contianer = Container.standard
        
        do {
            let value = try contianer.resolve(identifier)
            return value
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
}
