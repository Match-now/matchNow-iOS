//
//  matchNowAppDelegate.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import UIKit
import ComposableArchitecture
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

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
    
    // MARK: - Application Lifecycle Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Firebase 초기화 및 delegate 설정
        FirebaseApp.configure()
        
        return true
    }
    
    // Google 로그인을 위한 URL 처리
    func application(_ app: UIApplication,
                    open url: URL,
                    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
