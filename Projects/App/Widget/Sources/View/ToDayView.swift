//
//  ToDayView.swift
//  Widget
//
//  Created by 윤제 on 11/8/24.
//

import SwiftUI

import Domain
import Data
import Core

struct ToDayView: View {
    
    let date: Date
    let eventsToday: [CalendarEvent]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(date.formattedDateString(type: .simpleMonthDay))
                    .font(.system(size: 13, weight: .semibold))
                
                Spacer()
                    .frame(height: 2)
                
                if eventsToday.isEmpty {
                    Text("이벤트 없음")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(Color(uiColor: UIColor.systemGray2))
                } else if eventsToday.count <= 2 {
                    ForEach(eventsToday) { event in
                        EventView(event: event)
                    }
                } else if eventsToday.count > 2{
                    ForEach(eventsToday.prefix(2)) { event in
                        EventView(event: event)
                    }
                    Text("+\(eventsToday.count - 2)")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(Color(uiColor: UIColor.systemGray))
                }
                Spacer()
            }
            Spacer()
        }
        
    }
}

struct EventView: View {
    
    let event: CalendarEvent
    
    var body: some View {
        HStack(spacing: 4) {
            Rectangle()
                .frame(width: 3, height: 15)
                .foregroundColor(Color(uiColor: event.tagColor.toUIColor() ?? .blue))
                .cornerRadius(5)
            
            Text(event.title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(.black))
                .lineLimit(1)
        }
    }
}
