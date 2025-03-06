//
//  CommunityView.swift
//  matchNow
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI

enum CommunityRoute {
    case postDetail
    case signUp
    case createPost
}

struct CommunityView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("커뮤니티 뷰")
                
                Button {
                    if SignupManager.shared.isLogin {
                        path.append(CommunityRoute.postDetail)
                    } else {
                        path.append(CommunityRoute.signUp)
                    }
                } label: {
                    Text("게시물1")
                }
                
                Button {
                    if SignupManager.shared.isLogin {
                        path.append(CommunityRoute.createPost)
                    } else {
                        path.append(CommunityRoute.signUp)
                    }
                } label: {
                    Text("글쓰기")
                }
            }
            .navigationDestination(for: CommunityRoute.self) { route in
                switch route {
                case .postDetail:
                    PostDetailView()
                case .signUp:
                    SignUpView()
                case .createPost:
                    CreatePostView()
                }
            }
        }
    }
}

#Preview {
    CommunityView()
}
