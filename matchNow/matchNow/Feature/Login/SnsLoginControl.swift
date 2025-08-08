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

struct LoginItem {
    let idx: String?
    let email: String?
}

class SnsLoginControl: NSObject, ObservableObject {
    
    @Published var loginItem: LoginItem? = nil
    
    var loginKakaoResultSubject = PassthroughSubject<(Bool, String), Never>()
}

extension SnsLoginControl {
    
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
