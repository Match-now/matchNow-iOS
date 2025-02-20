//
//  HomeView.swift
//  livescore
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI

enum HomeRoute {
    case profile
    case signUp
    case matchDetail
    case calendar
}

struct HomeView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("홈 뷰")
            
                Button {
                    if SignupManager.shared.isLogin {
                        path.append(HomeRoute.profile)
                    } else {
                        path.append(HomeRoute.signUp)
                    }
                } label: {
                    Text("프로필")
                }
                //프로필 뷰 이동 , 로그인 안된경우 로그인 페이지
    
                Button {
                    path.append(HomeRoute.matchDetail)
                } label: {
                    Text("경기1")
                }
                //경기 상세로 이동
                
                Button {
                    if SignupManager.shared.isLogin {
                        print("관심경기 추가완료")
                    } else {
                        path.append(HomeRoute.signUp)
                    }
                } label: {
                    Text("관심경기 등록버튼")
                }
                //관심경기 등록버튼
                
                Button {
                    path.append(HomeRoute.calendar)
                } label: {
                    Text("달력")
                }
                //달력 뷰로 이동
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                case .signUp:
                    SignUpView()
                case .matchDetail:
                    MatchDetailView()
                case .calendar:
                    CalendarView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
