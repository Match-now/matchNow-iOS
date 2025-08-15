//
//  MainNaviView.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MainNaviReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id = UUID()
        var mainPage: MainReducer.State
        var isCheckingLogin = false
        
        init() {
            self.mainPage = MainReducer.State.initialState
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onLoad
        case task
        case mainPage(MainReducer.Action)
        case checkLoginStatus
        case loginStatusChecked(Result<Bool, Error>)
        case startMemberCheck
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.mainPage, action: \.mainPage) {
            MainReducer()
        }
        
        mainBuilder
    }
    
    @ReducerBuilder<State, Action>
    var mainBuilder: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onLoad:
                return .none
            case .task:
                return .run { send in
//                    // 🆕 앱 시작 시 종합 진단
//                    print("\n🚀 [MainNavi] 앱 시작 - 종합 진단 시작")
//                    print("=" * 50)
//                    
//                    // 1. 앱 환경 정보
//                    print("📱 앱 정보:")
//                    print("    Bundle ID: \(Bundle.main.bundleIdentifier ?? "Unknown")")
//                    print("    App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")")
                    
                    // 2. Keychain 상태 확인
                    //KeychainManager.debugKeychainStatus()
                    
                    // 3. 로그인 상태 확인
                    await send(.checkLoginStatus)
                }
            case .checkLoginStatus:
                state.isCheckingLogin = true
                return .run { send in
                    await send(.loginStatusChecked(
                        Result {
                            await AuthManager.shared.checkLoginStatus()
                        }
                    ))
                }
            case .loginStatusChecked(let result):
                state.isCheckingLogin = false
                switch result {
                case .success(let isLoggedIn):
                    if !isLoggedIn {
                        return .run { send in
                            await send(.startMemberCheck)
                        }
                    }
                    return .none
                case .failure:
                    return .run { send in
                        await send(.startMemberCheck)
                    }
                }
            case .startMemberCheck:
                if NaviRouter.shared.isMemberNaviPresent {
                    return .none
                }
                
                return .run { send in
                    try await Task.sleep(nanoseconds: 100_000_000) // 0.1초 지연
                    await MainActor.run {
                        NaviRouter.shared.isMemberNaviPresent = true
                        NaviRouter.shared.push(.memLogin)
                    }
                }
            default:
                return .none
            }
        }
    }
}

struct MainNaviView: View {
    let store: StoreOf<MainNaviReducer>
    @StateObject private var router = NaviRouter.shared
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        NavigationStack(path: $router.mainPath) {
            if store.isCheckingLogin {
                // 로그인 상태 확인 중 로딩 화면
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    Text("로그인 상태 확인 중...")
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            } else {
                MainPage(store: self.store.scope(state: \.mainPage, action: \.mainPage))
                    .navigationDestination(for: StackScreen.self) { stackScreen in
                        switch stackScreen.screen {
                        case .memLogin:
                            if let store = stackScreen.store as? StoreOf<LoginReducer> {
                                LoginPage(store: store)
                                    .navigationBarBackButtonHidden(true)
                            }
                        case .memRegist:
                            if let store = stackScreen.store as? StoreOf<MemberRegistReducer> {
                                MemberRegistView(store: store)
                                    .navigationBarBackButtonHidden(true)
                            }
                        case .memberNavi:
                            if let store = stackScreen.store as? StoreOf<MemberNaviReducer> {
                                MemberNaviView(store: store)
                                    .navigationBarBackButtonHidden(true)
                            }
                        default:
                            if let store = stackScreen.store as? StoreOf<BlankReducer> {
                                BlankView(store: store)
                            }
                            else {
                                EmptyView()
                            }
                        }
                    }
            }
        }
        .gesture(
            // 메인 레벨에서의 swipe back 제스처
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 && abs(value.translation.height) < 50 && router.mainPath.count > 0 {
                        router.pop()
                        // 마지막 화면이 회원가입 관련이면 플래그 초기화
                        if router.mainPath.isEmpty {
                            NaviRouter.shared.isMemberNaviPresent = false
                        }
                    }
                }
        )
        .onLoad {
            store.send(.onLoad)
        }
        .task {
            await store.send(.task).finish()
        }
        .onChange(of: authManager.isLoggedIn) { oldValue, newValue in
            // 로그인 상태가 변경되면 화면 갱신
            if newValue {
                // 로그인됨 - 로그인 화면이 있다면 닫기
                if !router.mainPath.isEmpty {
                    router.popRoot()
                    NaviRouter.shared.isMemberNaviPresent = false
                }
            }
        }
    }
}

#Preview {
    MainNaviView(
        store: Store(initialState: MainNaviReducer.State()) {
            MainNaviReducer()
        }
    )
}
