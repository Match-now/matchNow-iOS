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
    case noticeList
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    @State private var path = NavigationPath()
    @State private var isCalendarPresented = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                HomeHeaderView(
                    profileTap: {
                        path.append(HomeRoute.profile)
                    },
                    calendarTap: {
                        isCalendarPresented.toggle()
                    }
                )
                .padding(.bottom, 16)
                
                
                DateNavigationView(
                    selectedDate: viewModel.selectedDate,
                    prevDate: {
                        viewModel.moveDate(by: -1)
                    },
                    nextDate: {
                        viewModel.moveDate(by: 1)
                    }
                )
                .padding(.bottom,10)
                

                VStack {
                    NoticeView(noticeTap: {
                        path.append(HomeRoute.noticeList)
                    }, notice: viewModel.noticeMessage)
                    .padding(.horizontal, 4)
                    
                    CategoryView(selectedCategory: viewModel.selectedCategory, selectCategory: { newCategory in
                        viewModel.selectedCategory = newCategory
                    })
                }
                .padding(.vertical,8)
                .background(Color.gray.opacity(0.08))
                
                ScrollView {
                    ListHeaderView(title: "EPL")
                        ForEach(viewModel.matches, id: \.id) { match in
                            MatchRowView(match: match, onTap: {
                                path.append(HomeRoute.matchDetail)
                            }, onFavoriteTap: {
                                //즐찾
                            })
                    }
                }
                .padding(.horizontal,4)
                .scrollIndicators(.hidden)
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                case .signUp:
                    SignUpView()
                case .matchDetail:
                    MatchDetailView()
                case .noticeList:
                    NoticeListView()
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
