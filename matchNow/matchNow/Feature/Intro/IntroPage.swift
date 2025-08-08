//
//  IntroPage.swift
//  matchNow
//
//  Created by kimhongpil on 5/22/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct IntroReducer {
    @ObservableState
    struct State: Equatable {
        static let initialState = State()
        var isLoading = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
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
        
        case view(ViewAction)
        case inter(InternalAction)
        case introProcessFinished
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .send(.introProcessFinished)
            default:
                return .none
            }
        }
    }
}

struct IntroPage: View {
    let store: StoreOf<IntroReducer>
    @Environment(\.colorScheme) var scheme  // 다크모드
    
    var body: some View {
        ZStack {
            Color.darkModeColor(scheme: scheme)
            
            Image("login_logo")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(scheme == .light ? Color.init(hex: "1C67FF") : Color.white)
                .scaledToFit().frame(height: 31)
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                store.send(.view(.onAppear))
            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    IntroPage(
        store: Store(initialState: IntroReducer.State()) {
            IntroReducer()
        }
    )
}
