//
//  MainTabView.swift
//  matchNow
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Text("라이브")
                }
            CommunityView()
                .tabItem {
                    Text("커뮤니티")
                }
            NewsView()
                .tabItem {
                    Text("뉴스")
                }
            FollowView()
                .tabItem {
                    Text("관심경기")
                }
            OtherView()
                .tabItem {
                    Text("더보기")
                }
        }
    }
}

#Preview {
    MainTabView()
}
