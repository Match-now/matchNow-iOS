//
//  FollowView.swift
//  matchNow
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI

enum FollowRoute {
    case matchDetail
}

struct FollowView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("팔로우 뷰")
                
                Button {
                    path.append(FollowRoute.matchDetail)
                } label: {
                    Text("경기 1")
                }
            }
            .navigationDestination(for: FollowRoute.self) { route in
                switch route {
                case .matchDetail:
                    MatchDetailView()
                }
            }
        }
    }
}

#Preview {
    FollowView()
}
