//
//  LocalPushService.swift
//  Core
//
//  Created by 윤제 on 9/4/24.
//

import Foundation
import UserNotifications

final public class LocalPushService {
    
    public static let shared = LocalPushService()
    
    private init() {}
    
    public func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        
        do {
            return try await center.requestAuthorization(options: UNAuthorizationOptions(arrayLiteral: .alert, .sound, .badge))
        } catch {
            return false
        }
    }
    
    public func addNotification(
        identifier: String,
        title: String,
        body: String,
        date: Date
    ) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    public func addRepeatingNotification(
        identifier: String,
        title: String,
        body: String,
        hour: Int,
        minute: Int
    ) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // 매일 특정 시간에 반복되는 트리거 생성
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    public func removeNotification(identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
