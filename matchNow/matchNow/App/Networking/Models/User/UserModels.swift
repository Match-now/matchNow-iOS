//
//  UserModels.swift
//  matchNow
//
//  Created by psynet on 8/13/25.
//

import Foundation

struct SocialLoginRequest: Codable {
    let provider: String
    let socialId: String
    let email: String?
    let name: String
    let nickname: String?
    let profileImageUrl: String?
    let birthDate: String?
    let gender: String?
    let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case provider, socialId, email, name, nickname
        case profileImageUrl, birthDate, gender, phoneNumber
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "provider": provider,
            "socialId": socialId,
            "name": name
        ]
        
        if let email = email { dict["email"] = email }
        if let nickname = nickname { dict["nickname"] = nickname }
        if let profileImageUrl = profileImageUrl { dict["profileImageUrl"] = profileImageUrl }
        if let birthDate = birthDate { dict["birthDate"] = birthDate }
        if let gender = gender { dict["gender"] = gender }
        if let phoneNumber = phoneNumber { dict["phoneNumber"] = phoneNumber }
        
        return dict
    }
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
    
    func toDictionary() -> [String: Any] {
        return ["refreshToken": refreshToken]
    }
}

struct SocialLoginResponse: Codable {
    let success: Bool
    let data: LoginData
    let message: String
}

struct LoginData: Codable {
    let user: UserInfo
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
}

struct UserInfo: Codable {
    let id: Int
    let socialId: String
    let provider: String
    let email: String?
    let name: String
    let nickname: String?
    let profileImageUrl: String?
    let status: String
    let createdAt: String
}

struct RefreshTokenResponse: Codable {
    let success: Bool
    let data: TokenData
    let message: String
}

struct TokenData: Codable {
    let accessToken: String
    let refreshToken: String
}

struct UserProfileResponse: Codable, Equatable {
    let success: Bool
    let data: UserProfile
    let message: String
}

struct UserProfile: Codable, Equatable {
    let id: Int
    let socialId: String
    let provider: String
    let email: String?
    let name: String
    let nickname: String?
    let profileImageUrl: String?
    let birthDate: String?
    let gender: String?
    let phoneNumber: String?
    let status: String
    let preferredLanguage: String?
    let timezone: String?
    let marketingConsent: Bool?
    let pushNotificationEnabled: Bool?
    let settings: [String: String]?
    let createdAt: String
    let updatedAt: String
    let lastLoginAt: String?
    let lastLoginIp: String?
    
    // Equatable 구현 (settings 딕셔너리 비교를 위해)
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id &&
               lhs.socialId == rhs.socialId &&
               lhs.provider == rhs.provider &&
               lhs.email == rhs.email &&
               lhs.name == rhs.name &&
               lhs.nickname == rhs.nickname &&
               lhs.profileImageUrl == rhs.profileImageUrl &&
               lhs.birthDate == rhs.birthDate &&
               lhs.gender == rhs.gender &&
               lhs.phoneNumber == rhs.phoneNumber &&
               lhs.status == rhs.status &&
               lhs.preferredLanguage == rhs.preferredLanguage &&
               lhs.timezone == rhs.timezone &&
               lhs.marketingConsent == rhs.marketingConsent &&
               lhs.pushNotificationEnabled == rhs.pushNotificationEnabled &&
               lhs.settings == rhs.settings &&
               lhs.createdAt == rhs.createdAt &&
               lhs.updatedAt == rhs.updatedAt &&
               lhs.lastLoginAt == rhs.lastLoginAt &&
               lhs.lastLoginIp == rhs.lastLoginIp
    }
}
