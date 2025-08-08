//
//  MemberNaviView.swift
//  matchNow
//
//  Created by kimhongpil on 8/3/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MemberNaviReducer {
    struct State: Equatable, Identifiable {
        var id = UUID()
        var showAlert: Bool = false
        
        init() {
        }
    }
    
    enum Action {
        enum ViewAction {
            case onLoad
            case closeWithCancel
        }
        case view(ViewAction)
        case dismissProcess
        
        enum Destination {
            case moveReAuth
            case moveRegist
            case moveRestore
        }
        case dest(Destination)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {

        Reduce { state, action in
            switch action {
            case .view(let viewAct):
                return viewActionControl(state: &state, action: viewAct)
            
            case .dismissProcess:
                return .none
                //return dismissProcess()
            case .dest(let destAct):
                return destnationActionControl(state: &state, action: destAct)
            default:
                return .none
            }
        }
    }
    
//    func dismissProcess() -> Effect<Action> {
//        return .run { send in
//            await self.dismiss(transaction: .noAnimationTransaction)
//        }
//    }
    func viewActionControl(state: inout State, action: MemberNaviReducer.Action.ViewAction) -> Effect<Action> {
        switch action {
        case .onLoad:
            //let type = userSettings.userInfo.convertMemberType
            print("======= mem rootview")
            
            //return .send(.dest(.moveReAuth))
            return .send(.dest(.moveRegist))
        case .closeWithCancel:
            return .send(.dismissProcess)
        }
    }
    
    func destnationActionControl(state: inout State, action: MemberNaviReducer.Action.Destination) -> Effect<Action> {
        switch action {
        case .moveReAuth:
            state.showAlert = false
            NaviRouter.shared.memberPush(.memReAuth)
            return .none
        case .moveRegist:
            state.showAlert = false
            NaviRouter.shared.memberPush(.memRegist)
            return .none
        case .moveRestore:
            state.showAlert = false
            NaviRouter.shared.memberPush(.memRestore)
            return .none
        }
    }
}

struct MemberNaviView: View {
    var store: StoreOf<MemberNaviReducer>
    @ObservedObject var vs: ViewStoreOf<MemberNaviReducer>
    @StateObject var appState = AppState.shared
    @StateObject var router = NaviRouter.shared
    
    init(store: StoreOf<MemberNaviReducer>) {
        self.store = store
        self.vs = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            if vs.showAlert {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        vs.send(.dismissProcess, transaction: .noAnimationTransaction)
                    }
                
                MemberRegistAlertContentView() { action in
                    switch action {
                    case .restore:
                        vs.send(.dest(.moveRestore))
                    case .regist:
                        vs.send(.dest(.moveRegist))
                    case .linkInfo:
                        //vs.send(.dest(.moveNotice(noticeNo: "66")))
                        print("")
                    case .linkHow:
                        //vs.send(.dest(.moveNotice(noticeNo: "99")))
                        print("")
                    case .linkFind:
                        //vs.send(.dest(.moveNotice(noticeNo: "100")))
                        print("")
                    case .cancel:
                        vs.send(.view(.closeWithCancel))
                    }
                }
                .frame(width: UIScreen.main.bounds.width*0.87)
            }
            else {
                //Color.black.ignoresSafeArea()
                
                VStack {
                    //Divider().background(Color.black)
                    
                    NavigationStack(path: $router.memberPath) {
                        Color.white
                            .navigationDestination(for: StackScreen.self) { stackStore in
                                switch stackStore.screen {
//                                case .memReAuth:
//                                    if let store = stackStore.store as? StoreOf<MemberReAuthReducer> {
//                                        MemberReAuthView(store: store)
//                                    }
                                case .memRegist:
                                    if let store = stackStore.store as? StoreOf<MemberRegistReducer> {
                                        MemberRegistView(store: store)
                                    }
//                                case .noticeDetail:
//                                    if let store = stackStore.store as? StoreOf<NoticeDetailReducer> {
//                                        NoticeDetailView(store: store)
//                                    }
//                                case .termDetail:
//                                    if let store = stackStore.store as? StoreOf<TermReducer> {
//                                        TermView(store: store)
//                                    }
//                                case .registLsAccount:
//                                    if let store = stackStore.store as? StoreOf<MemberAccountRegistReducr> {
//                                        MemberAccountRegistView(store: store)
//                                    }
//                                case .memRestore:
//                                    if let store = stackStore.store as? StoreOf<MemberRestoreReducer> {
//                                        MemberRestoreView(store: store)
//                                    }
                                default:
                                    EmptyView()
                                }
                            }
                    }
                    .background(Color.white)
                    
                    Divider()
                        .background(Color.black)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
        .background(ClearBackground())
        .onChange(of: router.memberPath) {
            if router.memberPath.count == 0 { //멤버 네비 모두 팝되는지 감지
                vs.send(.dismissProcess, transaction: .noAnimationTransaction)
            }
        }
        .onLoad {
            vs.send(.view(.onLoad))
        }
    }
}

#Preview {
    MemberNaviView(store: Store(initialState: MemberNaviReducer.State()) {
        MemberNaviReducer()
    })
}
