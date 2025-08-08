//
//  matchNowApp.swift
//  matchNow
//
//  Created by hyunMac on 2/20/25.
//

import SwiftUI
import ComposableArchitecture

// 카카오 로그인
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct matchNowApp: App {
    @UIApplicationDelegateAdaptor(matchNowAppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        // Kakao 설정 (키 값을 번들에서 가져온다.)
        // AppDelegate에서 해도 되는데, 어차피 .onOpenURL로 카카오 설정을 해줘야 하기 때문에, 따로따로 구분짓기 싫어서 여기서 설정함
        if let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: nativeAppKey)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            matchNowAppView(store: Store(initialState: matchNowAppReducer.State()) {
                matchNowAppReducer()
            })
            .onOpenURL { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
        .onChange(of: self.scenePhase) {
            self.appDelegate.store.send(.didChangeScenePhase(self.scenePhase))
        }
    }
}
