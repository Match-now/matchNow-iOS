//
//  KeychainManager.swift
//  matchNow
//
//  Created by psynet on 8/15/25.
//

import Foundation
import Security

enum KeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unknown(OSStatus)
    
    var localizedDescription: String {
        switch self {
        case .itemNotFound:
            return "Keychain item not found"
        case .duplicateItem:
            return "Duplicate keychain item"
        case .invalidItemFormat:
            return "Invalid keychain item format"
        case .unknown(let status):
            return "Unknown keychain error: \(status)"
        }
    }
}

enum KeychainAccount: String {
    case accessToken = "matchnow_access_token"
    case refreshToken = "matchnow_refresh_token"
}

class KeychainManager {
    static let service = Bundle.main.bundleIdentifier ?? "com.matchnow.app"
    
    // MARK: - Save
    
    static func save(account: KeychainAccount, value: String, isForce: Bool = true) throws {
        print("🔐 [KEYCHAIN] 저장 시도: \(account.rawValue)")
        try save(account: account.rawValue, value: value.data(using: .utf8)!, isForce: isForce)
    }
    
    private static func save(account: String, value: Data, isForce: Bool = true) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: value as AnyObject,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly // 🔧 수정: 더 안전한 접근 정책
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            if isForce {
                print("🔐 [KEYCHAIN] 중복 항목 발견, 업데이트 시도: \(account)")
                try update(account: account, value: value)
                return
            } else {
                print("❌ [KEYCHAIN] 중복 항목 에러: \(account)")
                throw KeychainError.duplicateItem
            }
        }
        
        guard status == errSecSuccess else {
            print("❌ [KEYCHAIN] 저장 실패: \(account), status: \(status)")
            throw KeychainError.unknown(status)
        }
        
        print("✅ [KEYCHAIN] 저장 성공: \(account)")
    }
    
    // MARK: - Update
    
    private static func update(account: String, value: Data) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let attributes: [String: AnyObject] = [
            kSecValueData as String: value as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecDuplicateItem else {
            print("❌ [KEYCHAIN] 업데이트 중 중복 에러: \(account)")
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            print("❌ [KEYCHAIN] 업데이트 실패: \(account), status: \(status)")
            throw KeychainError.unknown(status)
        }
        
        print("✅ [KEYCHAIN] 업데이트 성공: \(account)")
    }
    
    // MARK: - Load
    
    static func get(account: KeychainAccount) throws -> String? {
        //print("🔍 [KEYCHAIN] 조회 시도: \(account.rawValue)")
        
        do {
            let data = try getData(account: account.rawValue)
            let result = String(decoding: data, as: UTF8.self)
            //print("✅ [KEYCHAIN] 조회 성공: \(account.rawValue), 길이: \(result.count)")
            return result
        } catch KeychainError.itemNotFound {
            //print("❌ [KEYCHAIN] 항목 없음: \(account.rawValue)")
            return nil
        } catch {
            print("❌ [KEYCHAIN] 조회 실패: \(account.rawValue), 에러: \(error)")
            throw error
        }
    }
    
    private static func getData(account: String) throws -> Data {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            print("❌ [KEYCHAIN] 데이터 조회 실패, status: \(status)")
            throw KeychainError.unknown(status)
        }
        
        guard let data = result as? Data else {
            print("❌ [KEYCHAIN] 데이터 형식 오류")
            throw KeychainError.invalidItemFormat
        }
        
        return data
    }
    
    // MARK: - Delete
    
    static func delete(account: KeychainAccount) throws {
        print("🗑️ [KEYCHAIN] 삭제 시도: \(account.rawValue)")
        
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("❌ [KEYCHAIN] 삭제 실패: \(account.rawValue), status: \(status)")
            throw KeychainError.unknown(status)
        }
        
        if status == errSecItemNotFound {
            print("⚠️ [KEYCHAIN] 삭제할 항목 없음: \(account.rawValue)")
        } else {
            print("✅ [KEYCHAIN] 삭제 성공: \(account.rawValue)")
        }
    }
    
    // MARK: - Clear All
    
    static func clearAll() {
        //print("🗑️ [KEYCHAIN] 모든 토큰 삭제 시작")
        
        do {
            try delete(account: .accessToken)
        } catch {
            print("❌ [KEYCHAIN] Access Token 삭제 실패: \(error)")
        }
        
        do {
            try delete(account: .refreshToken)
        } catch {
            print("❌ [KEYCHAIN] Refresh Token 삭제 실패: \(error)")
        }
        
        //print("✅ [KEYCHAIN] 모든 토큰 삭제 완료")
    }
    
    // 🆕 Keychain 상태 전체 확인
    static func debugKeychainStatus() {
        print("\n🔍 [KEYCHAIN] === Keychain 전체 상태 확인 ===")
        print("Service: \(service)")
        
        // Access Token 확인
        do {
            let accessToken = try get(account: .accessToken)
            if let token = accessToken {
                print("✅ Access Token 존재: 길이 \(token.count), 앞 20자: \(token.prefix(20))")
            } else {
                print("❌ Access Token 없음")
            }
        } catch {
            print("❌ Access Token 조회 에러: \(error)")
        }
        
        // Refresh Token 확인
        do {
            let refreshToken = try get(account: .refreshToken)
            if let token = refreshToken {
                print("✅ Refresh Token 존재: 길이 \(token.count), 앞 20자: \(token.prefix(20))")
            } else {
                print("❌ Refresh Token 없음")
            }
        } catch {
            print("❌ Refresh Token 조회 에러: \(error)")
        }
        
        print("=======================================\n")
    }
}
