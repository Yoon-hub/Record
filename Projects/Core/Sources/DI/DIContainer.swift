//
//  DIContainer.swift
//  Core
//
//  Created by 윤제 on 7/10/24.
//

import Foundation

public protocol Resolvable {
    /// 의존성 가져오기
    func resolve<V>(_ indentifier: InjectIdentifier<V>) throws -> V
}

public protocol Injectable: Resolvable, AnyObject {
    var dependencies: [AnyHashable: Any] { get set }
    
    func remove<V>(_ indentifier: InjectIdentifier<V>)
    func register<V>(_ indentifier: InjectIdentifier<V>, _ resolve: (Resolvable) throws -> V )
}

public extension Injectable {
    
    /// 의존성 가져오기
    func resolve<V>(_ identifier: InjectIdentifier<V>) throws -> V {
        guard let dependency = dependencies[identifier] as? V else {
            throw ResolvableError.dependencyNotFound(identifier.type, identifier.key)
        }
        return dependency
    }
    
    /// 의존성 가져올 시 InjectIdentifier 편하게 생성하기 위한 메서드
    func resolve<V>(
        type: V.Type? = nil,
        key: String? = nil
    ) throws -> V {
        try self.resolve(.by(type: type, key: key))
    }
    
    /// 의존성 삭제
    func remove<V>(_ indentifier: InjectIdentifier<V>) {
        dependencies.removeValue(forKey: indentifier)
    }
    
    /// 의존성 등록
    func register<V>(
        _ indentifier: InjectIdentifier<V>,
        _ resolve: (Resolvable) throws -> V
    ) {
        do {
            self.dependencies[indentifier] = try resolve(self)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    /// 의존성 등록 시 InjectIdentifier 편하게 생성하기 위한 메서드
    func register<V>(
        type: V.Type? = nil,
        key: String? = nil,
        _ resolve: (Resolvable) throws -> V
    ){
        self.register( .by(type: type, key: key), resolve)
    }
}


// MARK: - Error

/// 의존성 못가져올 시 사용할 Error Type
public enum ResolvableError: Error {
    case dependencyNotFound(Any.Type?, String?)
}

extension ResolvableError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .dependencyNotFound(type, key):
            var message = "Could not find dependency for "
            if let type = type {
                message += "type: \(type) "
            } else if let key = key {
                message += "key: \(key)"
            }
            return message
        }
    }
    
}
