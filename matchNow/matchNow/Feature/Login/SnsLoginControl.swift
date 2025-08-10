//
//  SnsLoginControl.swift
//  matchNow
//
//  Created by kimhongpil on 8/2/25.
//

import Foundation
import Combine

import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

// Firebase
import FirebaseCore
import FirebaseAuth

// Google Login
import GoogleSignIn

struct LoginItem {
    let idx: String?
    let email: String?
}

class SnsLoginControl: NSObject, ObservableObject {
    
    @Published var loginItem: LoginItem? = nil
    
    var loginKakaoResultSubject = PassthroughSubject<(Bool, String), Never>()
    var loginGoogleResultSubject = PassthroughSubject<(Bool, String), Never>()
    
    // Google Login
    static var rootViewController: UIViewController? {
        
        // 아래 deprecated 된 코드 수정
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        if var topController = window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        else {
            return nil
        }
    }
}

extension SnsLoginControl {
    //MARK: - Google Login
    func googleLogin() {
        
        // 메인 스레드에서 실행되도록 보장
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                self.loginGoogleResultSubject.send((false, ""))
                return
            }

            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            guard let rootViewController = SnsLoginControl.rootViewController else {
                self.loginGoogleResultSubject.send((false, ""))
                return
            }

            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, err in
                
                guard let self = self else { return }
                
                if let error = err {
                    print("Google Sign In Error: \(error.localizedDescription)")
                    self.loginGoogleResultSubject.send((false, ""))
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    print("Failed to get user or idToken")
                    self.loginGoogleResultSubject.send((false, ""))
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: user.accessToken.tokenString)

                Auth.auth().signIn(with: credential) { [weak self] result, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Firebase Auth Error: \(error.localizedDescription)")
                        self.loginGoogleResultSubject.send((false, ""))
                        return
                    }
                    
                    guard let user = GIDSignIn.sharedInstance.currentUser else {
                        print("Failed to get current user")
                        self.loginGoogleResultSubject.send((false, ""))
                        return
                    }
                    
                    let idx = user.userID ?? ""
                    if idx.isEmpty {
                        print("User ID is empty")
                        self.loginGoogleResultSubject.send((false, ""))
                        return
                    }
                    
                    print("Google Login Success with ID: \(idx)")
                    
                    // 메인 스레드에서 결과 전송
                    DispatchQueue.main.async {
                        self.loginGoogleResultSubject.send((true, idx))
                    }
                }
            }
        }
    }
    
    //MARK: - Kakao Login
    func kakaoLogin() {
        //카카오톡이 설치되어 있는지 확인하는 함수
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if error != nil {
                    self.loginKakaoResultSubject.send((false, ""))
                    return
                }

                if let _ = oauthToken{
                    UserApi.shared.me { user, error in
                        let idx = user?.id ?? 0
                        if idx == 0 {
                            self.loginKakaoResultSubject.send((false, ""))
                        }
                        else {
                            //fLog("idpilLog::: 카톡로그인 성공1 :>")
                            if let properties = user?.properties {
                                //fLog("idpilLog::: nickname : \(properties["nickname"] ?? "")")
                                //fLog("idpilLog::: profile_image : \(properties["profile_image"] ?? "")")
                                //fLog("idpilLog::: thumbnail_image : \(properties["thumbnail_image"] ?? "")")
                            }
                            self.loginKakaoResultSubject.send((true, String(idx)))
                        }
                    }
                }
            }
        }
        else {
            //카카오 계정으로 로그인하는 함수
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if error != nil {
                    self.loginKakaoResultSubject.send((false, ""))
                    return
                }

                if let _ = oauthToken{
                    UserApi.shared.me { user, error in
                        let idx = user?.id ?? 0
                        if idx == 0 {
                            self.loginKakaoResultSubject.send((false, ""))
                        }
                        else {
                            //fLog("idpilLog::: 카톡로그인 성공2 :>")
                            if let properties = user?.properties {
                                //fLog("idpilLog::: nickname : \(properties["nickname"] ?? "")")
                                //fLog("idpilLog::: profile_image : \(properties["profile_image"] ?? "")")
                                //fLog("idpilLog::: thumbnail_image : \(properties["thumbnail_image"] ?? "")")
                            }
                            self.loginKakaoResultSubject.send((true, String(idx)))
                        }
                    }
                }
            }
        }
    }
}
