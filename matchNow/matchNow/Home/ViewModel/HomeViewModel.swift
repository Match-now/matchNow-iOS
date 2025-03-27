//
//  HomeViewModel.swift
//  matchNow
//
//  Created by hyunMac on 3/27/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    
    func moveDate(by days: Int) {
        guard let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) else { return }
        selectedDate = newDate
    }
}
