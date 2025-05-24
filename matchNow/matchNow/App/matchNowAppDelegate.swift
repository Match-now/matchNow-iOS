//
//  matchNowAppDelegate.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import UIKit
import ComposableArchitecture

@Reducer
public struct matchNowAppDelegateReducer {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case didFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didFinishLaunching(launchOptions: _):
                return .none
            }
        }
    }
}

class matchNowAppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(initialState: matchNowAppReducer.State()) {
        matchNowAppReducer().transformDependency(\.self) { dependency in
        }
    }
}
