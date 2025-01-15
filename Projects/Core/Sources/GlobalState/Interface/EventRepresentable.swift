//
//  EventRepresentable.swift
//  Core
//
//  Created by 윤제 on 1/15/25.
//

import Foundation

/// CalendarEvent 에서 사용할 인터페이스
/// `GlobalState Event` 연관 값으로 사용
public protocol EventRepresentable {
    var id: String { get }
    var title: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var alarm: String? { get }
    var content: String? { get }
    var tagColor: String { get }
}
