//  AuthManager.swift
//  matchNow
//
//  Created by psynet on 8/15/25.
//

import Foundation
import Combine

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isLoggedIn: Bool = false
    @Published var userProfile: UserProfile?
    
    private init() {
        // 앱 시작시 토큰 존재 여부로 로그인 상태 초기화
        self.isLoggedIn = TokenManager.shared.getAccessToken() != nil
    }
    
    // 로그인 상태 확인
    func checkLoginStatus() async -> Bool {
        print("🔍 [DEBUG] 로그인 상태 확인 시작...")
        
        // 🆕 토큰 상태 디버깅
        TokenManager.shared.debugTokenStatus()
        
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("❌ [DEBUG] Access Token이 없어서 로그아웃 처리")
            await logout()
            return false
        }
        
        print("✅ [DEBUG] Access Token 존재함, 프로필 API 호출 시작...")
        
        // 토큰이 있으면 프로필 정보를 가져와서 토큰 유효성 검증
        do {
            let apiClient = ApiClient.liveValue
            let router = ApiRouter.user(UserRouter.profile)
            let result: Result<UserProfileResponse, LSError> = try await apiClient.apiRequest(router, as: UserProfileResponse.self)
            
            switch result {
            case .success(let response):
                print("✅ [DEBUG] 프로필 조회 성공")
                self.userProfile = response.data
                self.isLoggedIn = true
                return true
            case .failure(let error):
                print("❌ [DEBUG] 프로필 조회 실패: \(error)")
                // 🔧 수정: 새로운 에러 타입들을 활용한 처리
                switch error {
                case .tokenExpired:
                    print("🔄 [DEBUG] 토큰 만료 - 리프레시 시도")
                    // 토큰만 만료된 경우 - 리프레시 시도
                    do {
                        let refreshSuccess = try await TokenManager.shared.refreshTokens()
                        if refreshSuccess {
                            print("✅ [DEBUG] 토큰 갱신 성공 - 프로필 재조회")
                            // 갱신 성공시 다시 프로필 조회
                            return await checkLoginStatus()
                        } else {
                            print("❌ [DEBUG] 토큰 갱신 실패 - 로그아웃")
                            await logout()
                            return false
                        }
                    } catch {
                        print("❌ [DEBUG] 토큰 갱신 중 에러 - 로그아웃")
                        await logout()
                        return false
                    }
                case .unauthorized, .invalidToken, .accountDisabled, .refreshTokenExpired:
                    print("❌ [DEBUG] 복구 불가능한 인증 에러 - 즉시 로그아웃: \(error)")
                    // 복구 불가능한 인증 에러들 - 바로 로그아웃
                    await logout()
                    return false
                default:
                    print("❌ [DEBUG] 기타 에러 (네트워크 등) - 로그인 상태만 false: \(error)")
                    // 기타 에러 (네트워크 등) - 토큰은 유지하고 false 반환
                    self.isLoggedIn = false
                    return false
                }
            }
        } catch {
            print("❌ [AuthManager] 프로필 조회 중 예외 발생: \(error)")
            await logout()
            return false
        }
    }
    
    // 로그아웃
    func logout() async {
        print("🚪 [AuthManager] 로그아웃 처리 시작...")
        TokenManager.shared.clearTokens()
        self.isLoggedIn = false
        self.userProfile = nil
        print("✅ [AuthManager] 로그아웃 완료")
    }
    
    // 로그인 성공 처리
    func loginSuccess(accessToken: String, refreshToken: String, userInfo: UserInfo) async {
        print("🎉 [AuthManager] 로그인 성공 처리 시작...")
        TokenManager.shared.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
        self.isLoggedIn = true
        
        // 프로필 정보 다시 가져오기
        print("📄 [AuthManager] 프로필 정보 재조회 중...")
        let success = await checkLoginStatus()
        if success {
            print("✅ [AuthManager] 로그인 성공 처리 완료")
        } else {
            print("⚠️ [AuthManager] 로그인은 성공했지만 프로필 조회 실패")
        }
    }
}
