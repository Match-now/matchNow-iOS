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
                    Image(systemName: "tv.inset.filled")
                    Text("라이브")
                }
            CommunityView()
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("커뮤니티")
                }
//            NewsView()
//                .tabItem {
//                    Text("뉴스")
//                }
            FollowView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("관심경기")
                }
            OtherView()
                .tabItem {
                    Image(systemName: "line.horizontal.3")
                    Text("더보기")
                }
        }
    }
}

#Preview {
    MainTabView()
}
