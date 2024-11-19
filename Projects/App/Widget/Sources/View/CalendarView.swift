//
//  CalendarView.swift
//  Widget
//
//  Created by 윤제 on 11/18/24.
//

import SwiftUI

import Domain

struct CalenderView: View {
    @State var month: Date
    @State var offset: CGSize = CGSize()
    @State var clickedDates: Set<Date> = []
    @State var restDays: [RestDay] = []
    
    var body: some View {
        VStack {
            headerView
            calendarGridView
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        changeMonth(by: 1)
                    } else if gesture.translation.width > 100 {
                        changeMonth(by: -1)
                    }
                    self.offset = CGSize()
                }
        )
    }
    
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            Text(month, formatter: Self.dateFormatter)
                .font(.system(size: 13, weight: .semibold))
            
            Spacer()
                .frame(height: 4)
            
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                    } else {
                        
                        let date = getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        
                        let clicked = clickedDates.contains(date)
                        
                        let calendar = Calendar.current
                        let isToday = calendar.isDateInToday(date)
                        
                        // restDays 배열에 대해서 contains로 날짜 확인
                        let isRestDay = restDays.contains { restDay in
                            let calendar = Calendar.current
                            return calendar.isDate(restDay.date, inSameDayAs: date)
                        }
                        
                        CellView(day: day, clicked: clicked, isToday: isToday, isRestDay: isRestDay)
                            .font(.system(size: 11, weight: .semibold))
                            .onTapGesture {
                                if clicked {
                                    clickedDates.remove(date)
                                } else {
                                    clickedDates.insert(date)
                                }
                            }
                    }
                }
            }
        }
    }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    var day: Int
    var clicked: Bool = false
    var isToday: Bool = false
    var isRestDay: Bool = false
    
    init(day: Int, clicked: Bool, isToday: Bool, isRestDay: Bool) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isRestDay = isRestDay
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 7) // 동그라미 모양을 만들기 위해 cornerRadius를 크게 설정
                .frame(width: 14, height: 14)  // 동그라미 크기 설정
                .opacity(0.1) // 배경에 약간의 투명도를 설정 (필요에 따라 조정)
                .foregroundColor(isToday ? Color(uiColor: .label) : .clear)
                .overlay(
                    Text(String(day))
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(isRestDay ? .red : Color(uiColor: .label))
                )
            
            if clicked {
                Text("Click")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - 내부 메서드
private extension CalenderView {
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
}

// MARK: - Static 프로퍼티
extension CalenderView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월"
        return formatter
    }()
    
    static let weekdaySymbols = ["월", "화", "수", "목", "금", "토", "일"]
}
