//
//  matchNowApp.swift
//  matchNow
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct matchNowApp: App {
    @UIApplicationDelegateAdaptor(matchNowAppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            matchNowAppView(store: Store(initialState: matchNowAppReducer.State()) {
                matchNowAppReducer()
            })
        }
        .onChange(of: self.scenePhase) {
            self.appDelegate.store.send(.didChangeScenePhase(self.scenePhase))
        }
    }
}
