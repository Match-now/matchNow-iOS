//
//  CommunityPage.swift
//  matchNow
//
//  Created by kimhongpil on 5/22/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CommunityReducer {
    @ObservableState
    struct State: Equatable {
        static let initialState = State()
        var isLoading = false
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
            case requestCommunityList
            case responseCommunityList(Result<CommunityPageResponse, LSError>)
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
    
    func viewActionControl(state: inout State, action: CommunityReducer.Action.ViewAction) -> Effect<Action> {
        switch action {
        case .onLoad:
            return .none
        case .onAppear:
            return .run { send in
                await send(.inter(.requestCommunityList))
            }
        case .onDisappear:
            return .none
        case .readyToShowView:
            state.isLoading = false
            return .none
        }
    }
    
    func internalActionControl(state: inout State, action: CommunityReducer.Action.InternalAction) -> Effect<Action> {
        switch action {
        case .requestCommunityList:
            state.isLoading = true
            return .none
        case .responseCommunityList(let result):
            state.isLoading = false
            return .none
        }
    }
}

struct CommunityPage: View {
    let store: StoreOf<CommunityReducer>
    
    var body: some View {
        VStack {
            Text("Community Page !")
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    CommunityPage(
        store: Store(initialState: CommunityReducer.State()) {
            CommunityReducer()
        }
    )
}
