//
//  LoginPage.swift
//  matchNow
//
//  Created by kimhongpil on 8/2/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LoginReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id = UUID()
        
        // Alert
        var showAlert: Bool = false
        var alertTitle: String = ""
        var alertMessage: String = ""
        
        // Loading
        var loadingStatus: LoadingStatus = .Close
        
        // Join page navigation
        var showJoinPage: Bool = false
        var joinIdx: String = ""
        var joinType: LoginType = .google
        
        // Add username page navigation
        var showAddUserNamePage = false
        var authSuccessedLoginId: String?
        var authSuccessedLoginType: LoginUserType?
        
        // Look around
        var shouldDismiss: Bool = false
        
        // 🆕 SNS 사용자 정보 저장
        var snsUserName: String = ""
        var snsUserEmail: String?
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case backButtonTapped
        case lookAroundTapped
        
        // Login actions
        case loginWithKakao
        case loginWithApple
        case loginWithGoogle
        
        // Responses
        case kakaoLoginResponse(Result<String, Error>)
        case googleLoginResponse(Result<String, Error>)
        // 🆕 서버 로그인 응답 추가
        case serverLoginResponse(Result<SocialLoginResponse, Error>)
        
        // Alert
        case alertDismissed
        
        // Navigation
        case dismissView
    }
    
    @Dependency(\.snsLoginClient) var snsLoginClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                fLog("로그인페이지 onAppear")
                return .none
                
            case .onDisappear:
                fLog("로그인페이지 onDisappear")
                return .none
                
            case .backButtonTapped:
                NaviRouter.shared.popRoot()
                return .none
                
            case .lookAroundTapped:
                state.shouldDismiss = true
                return .run { send in
                    await send(.dismissView)
                }
                
            case .loginWithKakao:
                state.loadingStatus = .ShowWithTouchable
                return .run { send in
                    await send(.kakaoLoginResponse(
                        Result {
                            try await snsLoginClient.kakaoLogin()
                        }
                    ))
                }
                
            case .loginWithApple:
                // Apple 로그인 구현
                return .none
                
            case .loginWithGoogle:
                state.loadingStatus = .ShowWithTouchable
                return .run { send in
                    await send(.googleLoginResponse(
                        Result {
                            try await snsLoginClient.googleLogin()
                        }
                    ))
                }
            
            case .kakaoLoginResponse(let result):
                switch result {
                case .success(let socialId):
                    // 🔧 수정: SNS 로그인 성공 후 서버 로그인 호출
                    state.authSuccessedLoginId = socialId
                    state.authSuccessedLoginType = .KakaoTalk
                    
                    // TODO: 실제 카카오 SDK에서 사용자 정보 가져오기
                    state.snsUserName = "카카오사용자" // 실제 구현에서는 SDK에서 가져온 이름 사용
                    state.snsUserEmail = nil // 실제 구현에서는 SDK에서 가져온 이메일 사용
                    
                    let socialId = state.authSuccessedLoginId ?? ""
                    let name = state.snsUserName
                    let email = state.snsUserEmail
                    
                    return .run { send in
                        await send(.serverLoginResponse(
                            Result {
                                try await SnsLoginClient.loginToServer(
                                    provider: "kakao",
                                    socialId: socialId,
                                    name: name,
                                    email: email
                                )
                            }
                        ))
                    }
                case .failure(let error):
                    state.loadingStatus = .Close
                    fLog("Kakao login failed: \(error)")
                    return .none
                }
                
            case .googleLoginResponse(let result):
                switch result {
                case .success(let socialId):
                    // 🔧 수정: SNS 로그인 성공 후 서버 로그인 호출
                    state.authSuccessedLoginId = socialId
                    state.authSuccessedLoginType = .google
                    
                    // TODO: 실제 구글 SDK에서 사용자 정보 가져오기
                    state.snsUserName = "구글사용자" // 실제 구현에서는 SDK에서 가져온 이름 사용
                    state.snsUserEmail = nil // 실제 구현에서는 SDK에서 가져온 이메일 사용
                    
                    let socialId = state.authSuccessedLoginId ?? ""
                    let name = state.snsUserName
                    let email = state.snsUserEmail
                    
                    return .run { send in
                        await send(.serverLoginResponse(
                            Result {
                                try await SnsLoginClient.loginToServer(
                                    provider: "google",
                                    socialId: socialId,
                                    name: name,
                                    email: email
                                )
                            }
                        ))
                    }
                case .failure(let error):
                    state.loadingStatus = .Close
                    fLog("Google login failed: \(error)")
                    return .none
                }
            
            // 🆕 서버 로그인 응답 처리
            case .serverLoginResponse(let result):
                state.loadingStatus = .Close
                switch result {
                case .success(let response):
                    fLog("서버 로그인 성공: \(response.message)")
                    
                    if response.data.isNewUser {
                        // 신규 회원 - 추가 정보 입력 페이지로 이동 (필요한 경우)
                        state.showAddUserNamePage = true
                    } else {
                        // 기존 회원 - 로그인 완료 후 메인 화면으로
                        return .run { send in
                            try await Task.sleep(nanoseconds: 300_000_000) // 0.3초
                            await send(.dismissView)
                        }
                    }
                    return .none
                    
                case .failure(let error):
                    state.alertTitle = "로그인 오류"
                    if let lsError = error as? LSError {
                        state.alertMessage = "로그인에 실패했습니다."
                    } else {
                        state.alertMessage = error.localizedDescription
                    }
                    state.showAlert = true
                    return .none
                }
                
            case .alertDismissed:
                state.showAlert = false
                state.alertTitle = ""
                state.alertMessage = ""
                return .none
                
            case .dismissView:
                // 실제 화면 닫기는 상위 뷰에서 처리
                return .none
            }
        }
    }
}

struct LoginPage : View {
    @Bindable var store: StoreOf<LoginReducer>
    
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
                    store.send(.loginWithKakao)
                }
                .padding(.bottom, 20)
                
                LoginButtonView(iconName: "login_apple", snsName: "Apple", bgColor: Color.white, buttonType: .apple) {
                    store.send(.loginWithApple)
                }
                .padding(.bottom, 20)
                
                LoginButtonView(iconName: "login_google", snsName: "Google", bgColor: Color.white, buttonType: .google) {
                    store.send(.loginWithGoogle)
                }
            }
            .padding(.horizontal, sizeInfo.horizontalPadding)
            
            Spacer()
            
            Button {
                store.send(.lookAroundTapped)
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
        .onAppear {
            store.send(.onAppear)
        }
        .onDisappear {
            store.send(.onDisappear)
        }
        .overlay(
            // 로딩 인디케이터
            Group {
                if store.loadingStatus == .ShowWithTouchable {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .tint(.white)
                }
            }
        )
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
    LoginPage(store: Store(initialState: LoginReducer.State(), reducer: {
        LoginReducer()
    }))
}
