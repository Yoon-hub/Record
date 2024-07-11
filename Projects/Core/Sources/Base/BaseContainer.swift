//
//  BaseContainer.swift
//  Core
//
//  Created by 윤제 on 7/11/24.
//

import Foundation

public protocol BaseContainer {
    
    func registerDependencies()
    
}

public extension BaseContainer {
    
    var container: Container {
        Container.standard
    }
    
}

