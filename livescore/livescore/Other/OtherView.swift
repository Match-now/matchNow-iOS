//
//  OtherView.swift
//  livescore
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI

struct OtherView: View {
    var body: some View {
        VStack {
            Text("더보기 뷰")
            
            Button("로그아웃 테스트") {
                SignupManager.shared.isLogin = false
            }
        }
    }
}

#Preview {
    OtherView()
}
