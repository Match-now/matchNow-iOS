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

extension SnsLoginClient: DependencyKey {
    static let liveValue = Self(
        kakaoLogin: {
            return try await SnsLoginManager.shared.kakaoLogin()
        },
        googleLogin: {
            return try await SnsLoginManager.shared.googleLogin()
        }
    )
    
    static let testValue = Self(
        kakaoLogin: { "test_kakao_id" },
        googleLogin: { "test_google_id" }
    )
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
