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
        //@Presents var memNavi: MemberNaviReducer.State?
        
        init() {
            self.mainPage = MainReducer.State.initialState
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onLoad
        case task
        case mainPage(MainReducer.Action)
        case startMemberCheck
        //case memNavi(PresentationAction<MemberNaviReducer.Action>)
    }
    
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
                    await send(.startMemberCheck)
                }
            case .startMemberCheck:
                if NaviRouter.shared.isMemberNaviPresent {
                    return .none
                }
                //NaviRouter.shared.isMemberNaviPresent = true
                
                //state.memNavi = MemberNaviReducer.State()
                
                // MemberNaviView를 navigation으로 push
                //NaviRouter.shared.push(.memberNavi)
                
                //return .none
                
                // 직접 MemberRegistView로 이동 (MemberNaviView 건너뛰기)
                return .run { send in
                    try await Task.sleep(nanoseconds: 100_000_000) // 0.1초 지연
                    await MainActor.run {
                        NaviRouter.shared.isMemberNaviPresent = true
                        //NaviRouter.shared.push(.memRegist)
                        NaviRouter.shared.push(.memLogin)
                    }
                }
                
                
                
                
//            case .memNavi(let memNaviAction):
//                return memberNaviActionController(state: &state, action: memNaviAction)
            default:
                return .none
            }
        }
//        .ifLet(\.$memNavi, action: \.memNavi) {
//            MemberNaviReducer()
//        }
    }
    
//    func memberNaviActionController(state: inout State, action: PresentationAction<MemberNaviReducer.Action>) -> Effect<Action> {
//        switch action {
//        case .presented(.dismissProcess):
//            state.memNavi = nil
//            NaviRouter.shared.isMemberNaviPresent = false
//            print("==== memscreen dismiss")
//            //usersClient.sendEvent(.didCompleteMemberProcess(result: userSettings.memberType))
//            return .none
//        case .dismiss:
//            state.memNavi = nil
//            return .none
//        default:
//            return .none
//        }
//    }
}

struct MainNaviView: View {
    let store: StoreOf<MainNaviReducer>
    @StateObject private var router = NaviRouter.shared
    
    var body: some View {
        NavigationStack(path: $router.mainPath) {
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
//        .fullScreenCover(store: self.store.scope(state: \.$memNavi, action: \.memNavi)) { store in
//            MemberNaviView(store: store)
//                .transaction { t in
//                    t.disablesAnimations = true
//                }
//        }
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
            print("==== MainNaviView onLoad ====")
            store.send(.onLoad)
        }
        .task {
            await store.send(.task).finish()
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
