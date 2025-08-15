//
//  LivePage.swift
//  matchNow
//
//  Created by kimhongpil on 5/22/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LiveReducer {
    @ObservableState
    struct State: Equatable {
        static let initialState = State()
        var isLoading = false
        var userProfile: UserProfile?
        var profileError: String?
    }
    
    enum Action {
        case view(ViewAction)
        case inter(InternalAction)
        
        enum ViewAction {
            case onLoad
            case onAppear
            case onDisappear
            case readyToShowView
        }
        
        enum InternalAction {
            case requestUserProfile
            case responseUserProfile(Result<UserProfileResponse, LSError>)
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        mainBuilder
    }
    
    var mainBuilder: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(let viewAct):
                return viewActionControl(state: &state, action: viewAct)
            case .inter(let interAct):
                return internalActionControl(state: &state, action: interAct)
            }
        }
    }
    
    func viewActionControl(state: inout State, action: LiveReducer.Action.ViewAction) -> Effect<Action> {
        switch action {
        case .onLoad:
            return .none
        case .onAppear:
            return .run { send in
                await send(.inter(.requestUserProfile))
            }
        case .onDisappear:
            return .none
        case .readyToShowView:
            state.isLoading = false
            return .none
        }
    }
    
    func internalActionControl(state: inout State, action: LiveReducer.Action.InternalAction) -> Effect<Action> {
        switch action {
        case .requestUserProfile:
            state.isLoading = true
            state.profileError = nil
            return .run { send in
                await send(.inter(.responseUserProfile(
                    try await apiClient.apiRequest(.user(.profile), as: UserProfileResponse.self)
                )))
            }
        case .responseUserProfile(let result):
            state.isLoading = false
            switch result {
            case .success(let response):
                state.userProfile = response.data
                state.profileError = nil
            case .failure(let error):
                state.profileError = error.errorDescription
                fLog("프로필 조회 실패: \(error.errorDescription)")
            }
            return .none
        }
    }
}

struct LivePage: View {
    let store: StoreOf<LiveReducer>
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Live Page")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            if store.isLoading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("프로필 로딩 중...")
                        .padding(.leading)
                }
                .padding()
            } else if let profile = store.userProfile {
                VStack(alignment: .leading, spacing: 12) {
                    Text("프로필 정보")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ProfileRowView(title: "이름", value: profile.name)
                        ProfileRowView(title: "닉네임", value: profile.nickname ?? "설정 안됨")
                        ProfileRowView(title: "이메일", value: profile.email ?? "설정 안됨")
                        ProfileRowView(title: "제공업체", value: profile.provider.capitalized)
                        ProfileRowView(title: "상태", value: profile.status)
                        
                        if let phoneNumber = profile.phoneNumber {
                            ProfileRowView(title: "전화번호", value: phoneNumber)
                        }
                        
                        if let birthDate = profile.birthDate {
                            ProfileRowView(title: "생년월일", value: birthDate)
                        }
                        
                        if let gender = profile.gender {
                            ProfileRowView(title: "성별", value: gender == "male" ? "남성" : "여성")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    // 🆕 개발자 도구 섹션 (DEBUG 빌드에서만 표시)
                    #if DEBUG
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🔧 개발자 도구")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            Button("🔍 토큰 상태 확인") {
                                TokenManager.shared.debugTokenStatus()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            
                            Button("🔄 강제 토큰 갱신") {
                                Task {
                                    let result = try await TokenManager.shared.refreshTokens()
                                    print("토큰 갱신 결과: \(result)")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                            
                            Button("📋 Keychain 전체 상태") {
                                //KeychainManager.debugKeychainStatus()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    #endif
                    
                    // 로그아웃 버튼
                    Button(action: {
                        Task {
                            await authManager.logout()
                        }
                    }) {
                        Text("로그아웃")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            } else if let error = store.profileError {
                VStack {
                    Text("프로필 로딩 실패")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button("다시 시도") {
                        store.send(.view(.onAppear))
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

struct ProfileRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

#Preview {
    LivePage(
        store: Store(initialState: LiveReducer.State()) {
            LiveReducer()
        }
    )
}
