//
//  LoginButtonView.swift
//  matchNow
//
//  Created by kimhongpil on 8/2/25.
//

import SwiftUI

enum LoginButtonType: Int {
    case google
    case apple
    case kakaotalk
}

struct LoginButtonView : View {
    
    //@StateObject var languageManager = LanguageManager.shared
    
    var iconName: String
    var snsName: String
    var bgColor: Color
    let buttonType: LoginButtonType
    
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let horizontalPadding: CGFloat = 14.0
        static let padding: CGFloat = 30
        
        static let roundImageSize: CGSize = CGSize(width: 276.0, height: 42.0)
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
    
    private struct colorInfo {
        static let kakaotalkColor: Color = Color(red: 248/255.0, green: 218/255.0, blue: 51/255.0, opacity: 1)
    }
    
    var body: some View {
        Button {
            onPress()
        } label: {
            HStack(spacing: 0) {
                Image(iconName)
                
                Text(snsName)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray870)
            }
            .frame(height: 52)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(bgColor.cornerRadius(10))
            .shadow(color: Color.gray100, radius: 2, x: 0, y: 3)
        }
    }
}

#Preview {
    LoginButtonView(iconName: "login_google", snsName: "google", bgColor: Color.white, buttonType: .apple) {
        
    }
}
