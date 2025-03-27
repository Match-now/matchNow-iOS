//
//  HomeView.swift
//  matchNow
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI

enum HomeRoute {
    case profile
    case signUp
    case matchDetail
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    @State private var path = NavigationPath()
    @State private var isCalendarPresented = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HomeHeaderView(
                    profileTap: {
                        path.append(HomeRoute.profile)
                    },
                    calendarTap: {
                        isCalendarPresented.toggle()
                    }
                )
                
                DateNavigationView(
                    selectedDate: viewModel.selectedDate,
                    prevDate: {
                        viewModel.moveDate(by: -1)
                    },
                    nextDate: {
                        viewModel.moveDate(by: 1)
                    }
                )
                
                Spacer()
                
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
                
                
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                case .signUp:
                    SignUpView()
                case .matchDetail:
                    MatchDetailView()
                }
            }
            .sheet(isPresented: $isCalendarPresented) {
                CalendarView()
            }
        }
    }
}

#Preview {
    HomeView()
}
