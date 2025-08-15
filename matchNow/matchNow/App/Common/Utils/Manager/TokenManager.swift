//
//  TokenManager.swift
//  matchNow
//
//  Created by psynet on 8/14/25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private init() {
        debugTokenStatus()
    }
    
    // 토큰 저장
    func saveTokens(accessToken: String, refreshToken: String) {
        print("💾 [TokenManager] 토큰 저장 시작...")
        print("    - Access Token 길이: \(accessToken.count)")
        print("    - Refresh Token 길이: \(refreshToken.count)")
        
        do {
            try KeychainManager.save(account: .accessToken, value: accessToken)
            try KeychainManager.save(account: .refreshToken, value: refreshToken)
            
            print("✅ [TokenManager] 토큰 저장 완료")
            
            // 저장 후 즉시 확인
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.verifyTokensAfterSave()
            }
            
        } catch {
            print("❌ [TokenManager] 토큰 저장 실패: \(error)")
        }
    }
    
    // 🆕 저장 후 검증
    private func verifyTokensAfterSave() {
        print("🔍 [TokenManager] 저장 후 검증 중...")
        
        let savedAccessToken = getAccessToken()
        let savedRefreshToken = getRefreshToken()
        
        if savedAccessToken != nil && savedRefreshToken != nil {
            print("✅ [TokenManager] 저장 검증 성공")
        } else {
            print("❌ [TokenManager] 저장 검증 실패!")
            print("    - Access Token 존재: \(savedAccessToken != nil)")
            print("    - Refresh Token 존재: \(savedRefreshToken != nil)")
        }
    }
    
    // Access Token 가져오기
    func getAccessToken() -> String? {
        do {
            let token = try KeychainManager.get(account: .accessToken)
            
            if let token = token {
                //print("✅ [TokenManager] Access Token 조회 성공: 길이 \(token.count)")
                return token
            } else {
                //print("❌ [TokenManager] Access Token이 nil")
                return nil
            }
        } catch {
            print("❌ [TokenManager] Access Token 조회 실패: \(error)")
            return nil
        }
    }
    
    // Refresh Token 가져오기
    func getRefreshToken() -> String? {
        do {
            let token = try KeychainManager.get(account: .refreshToken)
            
            if let token = token {
                //print("✅ [TokenManager] Refresh Token 조회 성공: 길이 \(token.count)")
                return token
            } else {
                //print("❌ [TokenManager] Refresh Token이 nil")
                return nil
            }
        } catch {
            print("❌ [TokenManager] Refresh Token 조회 실패: \(error)")
            return nil
        }
    }
    
    // 토큰 삭제
    func clearTokens() {
        //print("🗑️ [TokenManager] 토큰 삭제 시작...")
        KeychainManager.clearAll()
        print("✅ [TokenManager] 토큰 삭제 완료")
        
        // 삭제 후 확인
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.verifyTokensAfterClear()
        }
    }
    
    // 🆕 삭제 후 검증
    private func verifyTokensAfterClear() {
        print("🔍 [TokenManager] 삭제 후 검증 중...")
        
        let accessToken = getAccessToken()
        let refreshToken = getRefreshToken()
        
        if accessToken == nil && refreshToken == nil {
            print("✅ [TokenManager] 삭제 검증 성공")
        } else {
            print("❌ [TokenManager] 삭제 검증 실패!")
            print("    - Access Token 존재: \(accessToken != nil)")
            print("    - Refresh Token 존재: \(refreshToken != nil)")
        }
    }
    
    // 토큰 갱신
    func refreshTokens() async throws -> Bool {
        guard let refreshToken = getRefreshToken() else {
            print("❌ [TokenManager] Refresh token이 없어서 갱신 불가")
            return false
        }
        
        print("🔄 [TokenManager] 토큰 갱신 시작...")
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        
        do {
            let router = ApiRouter.user(UserRouter.refreshToken(request))
            let apiClient = ApiClient.liveValue
            let result: Result<RefreshTokenResponse, LSError> = try await apiClient.apiRequest(router, as: RefreshTokenResponse.self)
            
            switch result {
            case .success(let response):
                print("✅ [TokenManager] 토큰 갱신 API 성공")
                saveTokens(accessToken: response.data.accessToken, refreshToken: response.data.refreshToken)
                return true
            case .failure(let error):
                print("❌ [TokenManager] 토큰 갱신 API 실패: \(error.errorDescription)")
                clearTokens()
                return false
            }
        } catch {
            print("❌ [TokenManager] 토큰 갱신 예외: \(error)")
            clearTokens()
            return false
        }
    }
    
    // 🆕 토큰 상태 상세 확인
    func debugTokenStatus() {
        // 1. Keychain 전체 상태 확인
        //KeychainManager.debugKeychainStatus()
        
        // 2. TokenManager 레벨에서 확인
        let accessToken = getAccessToken()
        let refreshToken = getRefreshToken()
        
        print("📊 [TokenManager] 상태 요약:")
        print("    - Access Token: \(accessToken != nil ? "✅ 존재" : "❌ 없음")")
        print("    - Refresh Token: \(refreshToken != nil ? "✅ 존재" : "❌ 없음")")
        
//        if let accessToken = accessToken {
//            print("    - Access Token 길이: \(accessToken.count)")
//            print("    - Access Token 미리보기: \(accessToken.prefix(30))...")
//        }
//        
//        if let refreshToken = refreshToken {
//            print("    - Refresh Token 길이: \(refreshToken.count)")
//            print("    - Refresh Token 미리보기: \(refreshToken.prefix(30))...")
//        }
//        
//        // 3. 앱 정보
//        print("📱 [TokenManager] 앱 정보:")
//        print("    - Bundle ID: \(Bundle.main.bundleIdentifier ?? "Unknown")")
//        print("    - Keychain Service: \(KeychainManager.service)")
//        
//        print("=============================================\n")
    }
    
    // 🆕 주기적 토큰 상태 모니터링 (개발 중에만 사용)
    func startTokenMonitoring() {
        #if DEBUG
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            print("⏰ [TokenManager] 주기적 토큰 상태 확인 (30초마다)")
            self.debugTokenStatus()
        }
        #endif
    }
}
