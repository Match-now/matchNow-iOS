//
//  SnsLoginClient.swift
//  matchNow
//
//  Created by kimhongpil on 8/10/25.
//

import SwiftUI
import ComposableArchitecture
import Combine

// MARK: - Types
enum LoginUserType: String, CaseIterable {
    case google = "google"
    case apple = "apple"
    case KakaoTalk = "kakaotalk"
}

enum LoginType: String, CaseIterable {
    case google = "google"
    case apple = "apple"
    case kakaotalk = "kakaotalk"
}

enum LoadingStatus {
    case Close
    case ShowWithTouchable
}

// MARK: - SnsLoginControl Dependency
struct SnsLoginClient {
    var kakaoLogin: @Sendable () async throws -> String
    var googleLogin: @Sendable () async throws -> String
}

// MARK: - Shared SnsLoginControl Manager
@MainActor
class SnsLoginManager: ObservableObject {
    static let shared = SnsLoginManager()
    private let snsControl = SnsLoginControl()
    
    private init() {}
    
    func kakaoLogin() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            
            cancellable = snsControl.loginKakaoResultSubject
                .sink { success, idx in
                    cancellable?.cancel()
                    if success {
                        continuation.resume(returning: idx)
                    } else {
                        continuation.resume(throwing: LoginError.kakaoLoginFailed)
                    }
                }
            
            snsControl.kakaoLogin()
        }
    }
    
    func googleLogin() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            
            cancellable = snsControl.loginGoogleResultSubject
                .sink { success, idx in
                    cancellable?.cancel()
                    if success {
                        continuation.resume(returning: idx)
                    } else {
                        continuation.resume(throwing: LoginError.googleLoginFailed)
                    }
                }
            
            snsControl.googleLogin()
        }
    }
}

//extension SnsLoginClient: DependencyKey {
//    static let liveValue = Self(
//        kakaoLogin: {
//            return try await SnsLoginManager.shared.kakaoLogin()
//        },
//        googleLogin: {
//            return try await SnsLoginManager.shared.googleLogin()
//        }
//    )
//    
//    static let testValue = Self(
//        kakaoLogin: { "test_kakao_id" },
//        googleLogin: { "test_google_id" }
//    )
//}
extension SnsLoginClient: DependencyKey {
    static let liveValue = Self(
        kakaoLogin: {
            return try await SnsLoginManager.shared.kakaoLogin()
        },
        googleLogin: {
            return try await SnsLoginManager.shared.googleLogin()
        }
    )
    
    // 🆕 서버 로그인 메서드 추가
    static func loginToServer(provider: String, socialId: String, name: String, email: String? = nil) async throws -> SocialLoginResponse {
        let request = SocialLoginRequest(
            provider: provider,
            socialId: socialId,
            email: email,
            name: name,
            nickname: nil,
            profileImageUrl: nil,
            birthDate: nil,
            gender: nil,
            phoneNumber: nil
        )
        
        let router = ApiRouter.user(UserRouter.socialLogin(request))
        let apiClient = ApiClient.liveValue
        let result: Result<SocialLoginResponse, LSError> = try await apiClient.apiRequest(router, as: SocialLoginResponse.self)
        
        switch result {
        case .success(let response):
            // 토큰 저장
            TokenManager.shared.saveTokens(
                accessToken: response.data.accessToken,
                refreshToken: response.data.refreshToken
            )
            return response
        case .failure(let error):
            throw error
        }
    }
}

extension DependencyValues {
    var snsLoginClient: SnsLoginClient {
        get { self[SnsLoginClient.self] }
        set { self[SnsLoginClient.self] = newValue }
    }
}

// MARK: - Login Error
enum LoginError: Error, LocalizedError {
    case kakaoLoginFailed
    case googleLoginFailed
    case userCheckFailed
    case loginFailed
    
    var errorDescription: String? {
        switch self {
        case .kakaoLoginFailed:
            return "카카오 로그인에 실패했습니다."
        case .googleLoginFailed:
            return "구글 로그인에 실패했습니다."
        case .userCheckFailed:
            return "사용자 확인에 실패했습니다."
        case .loginFailed:
            return "로그인에 실패했습니다."
        }
    }
}
