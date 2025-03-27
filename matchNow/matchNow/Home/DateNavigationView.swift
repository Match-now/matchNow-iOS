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
        HStack {
            Button(action: prevDate) {
                Text(formattedDate(changeDate(by: -1, date: selectedDate)))
            }
            
            Spacer()
            
            Text(formattedCenterDate(selectedDate))
            
            Spacer()
            
            Button(action: nextDate) {
                Text(formattedDate(changeDate(by: 1, date: selectedDate)))
            }
        }
        .padding()
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
    
    private func formattedCenterDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let centerDate = dateFormatter.string(from: date)
        return "오늘(\(centerDate))"
    }
}

#Preview {
    DateNavigationView(selectedDate: Date(), prevDate: {}, nextDate: {})
}
