//
//  HomeViewModel.swift
//  matchNow
//
//  Created by hyunMac on 3/27/25.
//

import Foundation

// 매치 데이터 구조 임시
struct Match: Identifiable {
    let id: Int
    //축구, 야구 등등
    let league: String
    let noticeMessage: String
    //경기 상태, 뭐 시작시간이나 지금 얼마나 진행됐는지
    let status: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int?
    let awayScore: Int?
    // 어떻게 받아와질지 모름, 지금은 배당 스트링 배열로 3개 나눠서 표현
    let odds: String
}

class HomeViewModel: ObservableObject {
    // 날짜
    @Published var selectedDate: Date = Date()
    // 알림
    @Published var noticeMessage: String = "테스트 메시지 입니다"
    // 선택된 카테고리
    @Published var selectedCategory: Categories = Categories.All
    // 서버로 부터 받아온 매치 리스트
    @Published var matches: [Match] = [Match(id: 1, league: "EPL", noticeMessage: "맨체스터의 주인은 맨시티다..? 이거는 이제 반박 못 할 것 같은데요 맨유팬 여러분 인정 하시나요??", status: "전반 12", homeTeam: "맨유", awayTeam: "맨시티", homeScore: 1, awayScore: 2, odds: "5.06 | 1.55")]
    
    func moveDate(by days: Int) {
        guard let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) else { return }
        selectedDate = newDate
    }
}
