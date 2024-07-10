//
//  InjectIdentifier.swift
//  Core
//
//  Created by 윤제 on 7/10/24.
//

import Foundation

/// 의존성 주입 시 타입과 키값을 저장하는 구조체
public struct InjectIdentifier<V> {
    private(set) var type: V.Type?
    private(set) var key: String?
    
    init(
        type: V.Type? = nil,
        key: String? = nil
    ) {
        self.type = type
        self.key = key
    }
}

/// Hashable 프로토콜을 활용하여 비교 가능하도록
extension InjectIdentifier: Hashable {
    public static func == (
        lhs: InjectIdentifier<V>,
        rhs: InjectIdentifier<V>
    ) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
        if let type = type {
            hasher.combine(ObjectIdentifier(type))
        }
    }
}

extension InjectIdentifier {
    public func by(
        type: V.Type? = nil,
        key: String? = nil
    ) -> InjectIdentifier {
        .init(type: type, key: key)
    }
}
