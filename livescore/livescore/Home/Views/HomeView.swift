//
//  HomeView.swift
//  livescore
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("홈 뷰")
                NavigationLink(destination: ProfileView()) {
                    Text("프로필로")
                }
                //프로필 뷰 이동
                
                NavigationLink(destination: MatchDetailView()) {
                    Text("경기1")
                }
                //경기 상세 뷰 이동
            }
        }
    }
}

#Preview {
    HomeView()
}
