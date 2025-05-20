//
//  matchNowAppDelegate.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import UIKit
import ComposableArchitecture

@Reducer
public struct matchNowAppDelegate {
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
                print("===== appdelegate: didfinish")
                return .none
            }
        }
    }
}

class pettiAppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(initialState: pettiAppReducer.State()) {
        pettiAppReducer().transformDependency(\.self) { dependency in
        }
    }
    
    
}
