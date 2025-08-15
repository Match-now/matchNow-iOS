//
//  TokenManager.swift
//  matchNow
//
//  Created by psynet on 8/14/25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private init() {}
    
    // 토큰 저장
    func saveTokens(accessToken: String, refreshToken: String) {
        do {
            try KeychainManager.save(account: .accessToken, value: accessToken)
            try KeychainManager.save(account: .refreshToken, value: refreshToken)
        } catch {
            print("토큰 저장 실패: \(error)")
        }
    }
    
    // Access Token 가져오기
    func getAccessToken() -> String? {
        do {
            return try KeychainManager.get(account: .accessToken)
        } catch {
            print("Access Token 가져오기 실패: \(error)")
            return nil
        }
    }
    
    // Refresh Token 가져오기
    func getRefreshToken() -> String? {
        do {
            return try KeychainManager.get(account: .refreshToken)
        } catch {
            print("Refresh Token 가져오기 실패: \(error)")
            return nil
        }
    }
    
    // 토큰 삭제
    func clearTokens() {
        KeychainManager.clearAll()
    }
    
    // 토큰 갱신
    func refreshTokens() async throws -> Bool {
        guard let refreshToken = getRefreshToken() else { return false }
        
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        let router = ApiRouter.user(UserRouter.refreshToken(request))
        
        do {
            let apiClient = ApiClient.liveValue
            let result: Result<RefreshTokenResponse, LSError> = try await apiClient.apiRequest(router, as: RefreshTokenResponse.self)
            
            switch result {
            case .success(let response):
                saveTokens(accessToken: response.data.accessToken, refreshToken: response.data.refreshToken)
                return true
            case .failure:
                clearTokens()
                return false
            }
        } catch {
            clearTokens()
            return false
        }
    }
}
