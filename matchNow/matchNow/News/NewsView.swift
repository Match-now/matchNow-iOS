//
//  NewsView.swift
//  matchNow
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI

enum NewsRoute {
    case newsDetail
}

struct NewsView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("뉴스 뷰")
                Button {
                    path.append(NewsRoute.newsDetail)
                } label: {
                    Text("뉴스 보기")
                }
            }
            .navigationDestination(for: NewsRoute.self) { route in
                switch route {
                case .newsDetail:
                    NewsDetailView()
                }
            }
        }
    }
}

#Preview {
    NewsView()
}
