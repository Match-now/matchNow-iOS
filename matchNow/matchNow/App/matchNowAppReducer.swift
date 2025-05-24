//
//  matchNowAppReducer.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct matchNowAppReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
        
        public var appDelegate: matchNowAppDelegateReducer.State
        
        var intro: IntroReducer.State?
        var mainNaviState = MainNaviReducer.State()
        
        var isLoadedView = false
        
        public init(appDelegate: matchNowAppDelegateReducer.State = matchNowAppDelegateReducer.State()) {
            self.appDelegate = appDelegate
            
            // 앱 시작 시 intro 상태를 초기화합니다
            self.intro = IntroReducer.State()
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case appDelegate(matchNowAppDelegateReducer.Action)
        case didChangeScenePhase(ScenePhase)
        case onAppear
        case onLoad
        case introAction(IntroReducer.Action)
        case mainNaviAction(MainNaviReducer.Action)
    }
    
    public var body: some Reducer<State, Action> {
        self.coreBuilder
    }
    
    @ReducerBuilder<State, Action>
    var coreBuilder: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.appDelegate, action: \.appDelegate) {
            matchNowAppDelegateReducer()
        }
        
        Scope(state: \.mainNaviState, action: \.mainNaviAction) {
            MainNaviReducer()
        }
        
        .ifLet(\.intro, action: \.introAction) {
            IntroReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onLoad:
                if state.isLoadedView == false {
                    state.intro = IntroReducer.State()
                }
                state.isLoadedView = true
                return .none
            case .didChangeScenePhase(.active):
                return .none
            case .introAction(let introAction):
                switch introAction {
                case .introProcessFinished:
                    state.intro = nil
                default:
                    return .none
                }
                return .none
            default:
                return .none
            }
        }
    }
}
