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
        
        init() {
            self.mainPage = MainReducer.State.initialState
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case mainPage(MainReducer.Action)
        case task
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
            case .task:
                return .none
            default:
                return .none
            }
        }
    }
}

struct MainNaviView: View {
    let store: StoreOf<MainNaviReducer>
    @StateObject private var router = NaviRouter.shared
    
    var body: some View {
        NavigationStack(path: $router.tmpScreens) {
            MainPage(store: self.store.scope(state: \.mainPage, action: \.mainPage))
                .navigationDestination(for: StackScreen.self) { stackScreen in
                    switch stackScreen.screen {
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
}

#Preview {
    MainNaviView(
        store: Store(initialState: MainNaviReducer.State()) {
            MainNaviReducer()
        }
    )
}
