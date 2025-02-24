//
//  SignUpView.swift
//  matchNow
//
//  Created by hyunMac on 2/21/25.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        Text("로그인뷰")
        
        Button("로그인 테스트") {
            SignupManager.shared.isLogin = true
        }
    }
}

#Preview {
    SignUpView()
}
