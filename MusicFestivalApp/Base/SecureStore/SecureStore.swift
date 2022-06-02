//
//  SecureStore.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 15/12/2021.
//

import Foundation
import Security

enum SecureStoreError : Error {
    case invalidContent
    case failure(status : OSStatus)
}

class SecureStore {
    private func setupQueryDictionnary(forKey key: String) throws -> [CFString: Any] {
        guard let keyData = key.data(using: .utf8) else {
            print("Error ! Could not convert the key to the expected format")
            throw SecureStoreError.invalidContent
        }
        let queryDictionnary: [CFString: Any] = [kSecClass: kSecClassGenericPassword, kSecAttrAccount: keyData]
        return queryDictionnary
    }
    
    func set(entry: String, forKey key: String) throws {
        guard !entry.isEmpty && !key.isEmpty else {
            print("Can't add an empty string to the keychain")
            throw SecureStoreError.invalidContent
        }
        try removeEntry(forKey: key)
        var queryDictionnary = try setupQueryDictionnary(forKey: key)
        queryDictionnary[kSecValueData] = entry.data(using: .utf8)
        let status = SecItemAdd(queryDictionnary as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecureStoreError.failure(status: status)
        }
    }
    
    func entry(forKey key: String) throws -> String? {
        guard !key.isEmpty else {
            print("Key must be valid")
            throw SecureStoreError.invalidContent
        }
        var queryDictionnary = try setupQueryDictionnary(forKey: key)
        queryDictionnary[kSecReturnData] = kCFBooleanTrue
        queryDictionnary[kSecMatchLimit] = kSecMatchLimitOne
        var data : AnyObject?
        let status = SecItemCopyMatching(queryDictionnary as CFDictionary, &data)
        guard status == errSecSuccess else {
            throw SecureStoreError.failure(status: status)
        }
        guard let itemData = data as? Data,
              let result = String(data: itemData, encoding: .utf8) else {
                  return nil
        }
        return result
    }
    
    func removeEntry(forKey key: String) throws {
        guard !key.isEmpty else {
            print("Key must be valid")
            throw SecureStoreError.invalidContent
        }
        let queryDictionnary = try setupQueryDictionnary(forKey: key)
        SecItemDelete(queryDictionnary as CFDictionary)
    }
}
