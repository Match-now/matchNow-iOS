//
//  LoginPage.swift
//  matchNow
//
//  Created by kimhongpil on 8/2/25.
//

import SwiftUI

struct LoginPage : View {
    @State var showBottomSheetLanguageView = false
    @StateObject var viewModel = LoginViewModel()
    @State var lang: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private struct sizeInfo {
        static let horizontalPadding: CGFloat = 20
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                
            }, label: {
                Image("login_back")
                    .resizable()
                    .scaledToFit().frame(height: 24)
                    .padding(.vertical, 10)
                    .padding(.leading, sizeInfo.horizontalPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            
            Image("login_logo")
                .resizable()
                .scaledToFit().frame(height: 31) // 이미지 높이에 맞게 비율유지
                .padding(.bottom, 50)
                .padding(.top, 120)
            
            Divider()
                .overlay(Color.init(hex: "D9D9D9"))
                .frame(height: 1)
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            
            Group {
                LoginButtonView(iconName: "login_kakaotalk", snsName: "se_login_kakao", bgColor: Color.init(hex: "FEE500"), buttonType: .kakaotalk) {
                    viewModel.loginWithKakao()
                }
                .padding(.bottom, 20)
                
                LoginButtonView(iconName: "login_apple", snsName: "Apple", bgColor: Color.white, buttonType: .apple) {
                    //viewModel.loginWithApple()
                }
                .padding(.bottom, 20)
                
                LoginButtonView(iconName: "login_google", snsName: "Google", bgColor: Color.white, buttonType: .google) {
                    //viewModel.loginWithGoogle()
                }
            }
            .padding(.horizontal, sizeInfo.horizontalPadding)
            
            Spacer()
            
            Button {
                //                        userManager.isLogin = false
                //                        userManager.isLogout = false
                //                        userManager.isLookAround = true
                //self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("d_look_around")
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray870)
                    .frame(height: 42, alignment: .center)
                    .padding(.horizontal, sizeInfo.horizontalPadding)
                    .padding(.bottom, 20.0 + DefineSize.SafeArea.bottom)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear() {
            fLog("로그인페이지 onAppear")
        }
        .onDisappear() {
            fLog("로그인페이지 onDisappear")
        }
    }
    
    var recentLoginAccountView: some View {
        HStack(alignment: .center, spacing: 0) {
            Image("icon_outline_danger")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color.gray500)
                .frame(width: 16, height: 16)
            
            Group {
                Text(" ")
                Text("c_recent_login_account")
                Text(" ")
                //Text(userManager.oldLoginType)
            }
            .font(Font.caption11218Regular)
            .foregroundColor(Color.gray500)
        }
        .frame(height: 16)
    }
    
}

#Preview {
    LoginPage()
}
