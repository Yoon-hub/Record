//
//  GlobalStateProvider.swift
//  Core
//
//  Created by 윤제 on 11/28/24.
//

import Foundation

import ReactorKit

public enum GlobalEvent {
    case caldenarUIUpdate
    case didRecivekakaoAppScheme(EventRepresentable)
    case calednarEventUpdate
}

public protocol GlobalStateProvider {
    var event: PublishSubject<GlobalEvent> { get }
    func sendEvent(_ event: GlobalEvent)
}

final public class GlobalStateProviderImpl: GlobalStateProvider {
    public let event = PublishSubject<GlobalEvent>()
    
    public init() {}
    
    public func sendEvent(_ event: GlobalEvent) {
        self.event.onNext(event)
    }
}
