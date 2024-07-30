//
//  SwiftDataRepositoryProtocol.swift
//  Domain
//
//  Created by 윤제 on 7/24/24.
//

import Foundation
import SwiftData

public protocol SwiftDataRepositoryProtocol {
    
    associatedtype T: PersistentModel
    
    func insertData(data: T) async
    func fetchData() async throws -> [T]
}
