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
