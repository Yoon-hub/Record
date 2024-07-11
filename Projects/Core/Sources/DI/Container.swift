//
//  Container.swift
//  Core
//
//  Created by 윤제 on 7/11/24.
//

import Foundation

public class Container: Injectable {
    
    public static var standard = Container()
    
    public var dependencies: [AnyHashable : Any] = [:]
}
