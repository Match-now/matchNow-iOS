//
//  DateNavigationView.swift
//  matchNow
//
//  Created by hyunMac on 3/27/25.
//

import SwiftUI

struct DateNavigationView: View {
    let selectedDate: Date
    let prevDate: () -> Void
    let nextDate: () -> Void
    
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            Button(action: prevDate) {
                let leftDate = changeDate(by: -1, date: selectedDate)
                let isToday = Calendar.current.isDateInToday(leftDate)
                Text(isToday ? formattedTodayDate(leftDate) : formattedDate(leftDate))
                    .font(.caption)
                    .frame(width: 100, alignment: .center)
                    .foregroundStyle(.black)
                    .opacity(0.8)
            }
//            .frame(minWidth: 44, minHeight: 44)
            //HIG 맞춰야하면 추가
            
            Spacer()
            
            VStack {
                let isToday = Calendar.current.isDateInToday(selectedDate)
                Text(isToday ? formattedTodayDate(selectedDate) : formattedDate(selectedDate))
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 120, alignment: .center)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .frame(width: 30, height: 3)
                                .offset(y:10)
                            //HIG 맞춰야하면 버튼에 따라 알맞게 변환할것
                                .foregroundStyle(.blue)
                        }
            }
            
            Spacer()
            
            Button(action: nextDate) {
                let leftDate = changeDate(by: 1, date: selectedDate)
                let isToday = Calendar.current.isDateInToday(leftDate)
                Text(isToday ? formattedTodayDate(leftDate) : formattedDate(leftDate))
                    .font(.caption)
                // caption 사이즈 12
                    .frame(width: 100, alignment: .center)
                    .foregroundStyle(.black)
                    .opacity(0.8)
            }
//            .frame(minWidth: 44, minHeight: 44)
            //HIG맞춰야하면추가
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func changeDate(by days: Int, date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd (E)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    private func formattedTodayDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let centerDate = dateFormatter.string(from: date)
        return "오늘 (\(centerDate))"
    }
}

#Preview {
    DateNavigationView(selectedDate: Date(), prevDate: {}, nextDate: {})
}
