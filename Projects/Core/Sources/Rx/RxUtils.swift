//
//  RxUtils.swift
//  Core
//
//  Created by 윤제 on 7/12/24.
//

import Foundation

import RxSwift

public enum RxConst {
    static public var milliseconds100Interval: RxTimeInterval {
        return .milliseconds(100)
    }
    
    static public var milliseconds300Interval: RxTimeInterval {
        return .milliseconds(300)
    }
}
