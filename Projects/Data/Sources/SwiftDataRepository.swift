//
//  SwiftDataRepository.swift
//  Data
//
//  Created by 윤제 on 7/23/24.
//

import Foundation
import SwiftData

import Domain

public final class SwiftDataRepository<T: PersistentModel>: SwiftDataRepositoryProtocol {
    
    public init() {
        let configure = ModelConfiguration()
        do {
            print("configure Init")
            container = try ModelContainer(for: T.self, configurations: configure)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    let container: ModelContainer
    
    
    public func insertData(data: T) {
        Task { @MainActor in
            let context = container.mainContext
            context.insert(data)
            
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    public func fetchData() async throws -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: nil)
        
        let context = container.mainContext
        let data = try context.fetch(descriptor)
        return data
    }
    
    public func deleteData(data: T) async {
        let context = await container.mainContext
        context.delete(data)
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
