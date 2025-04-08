//
//  HomeViewModel.swift
//  matchNow
//
//  Created by hyunMac on 3/27/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    // 날짜
    @Published var selectedDate: Date = Date()
    // 알림
    @Published var noticeMessage: String = "테스트 메시지 입니다"
    // 선택된 카테고리
    @Published var selectedCategory: Categories = Categories.All
    
    func moveDate(by days: Int) {
        guard let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) else { return }
        selectedDate = newDate
    }
}
