//
//  KeychainManager.swift
//  matchNow
//
//  Created by psynet on 8/15/25.
//

import Foundation

enum KeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unknown(OSStatus)
}

enum KeychainAccount: String {
    case accessToken = "matchnow_access_token"
    case refreshToken = "matchnow_refresh_token"
}

class KeychainManager {
    static let service = Bundle.main.bundleIdentifier ?? "com.matchnow.app"
    
    // MARK: - Save
    
    static func save(account: KeychainAccount, value: String, isForce: Bool = true) throws {
        try save(account: account.rawValue, value: value.data(using: .utf8)!, isForce: isForce)
    }
    
    private static func save(account: String, value: Data, isForce: Bool = true) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: value as AnyObject,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            if isForce {
                try update(account: account, value: value)
                return
            } else {
                throw KeychainError.duplicateItem
            }
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
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
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    // MARK: - Load
    
    static func get(account: KeychainAccount) throws -> String? {
        do {
            let data = try getData(account: account.rawValue)
            return String(decoding: data, as: UTF8.self)
        } catch KeychainError.itemNotFound {
            return nil
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
            throw KeychainError.unknown(status)
        }
        
        guard let data = result as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        return data
    }
    
    // MARK: - Delete
    
    static func delete(account: KeychainAccount) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
    
    // MARK: - Clear All
    
    static func clearAll() {
        try? delete(account: .accessToken)
        try? delete(account: .refreshToken)
    }
}
