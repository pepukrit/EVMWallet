//
//  KeyChain.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 27/3/2565 BE.
//

import Foundation

final class KeyChainManager {
    static let shared = KeyChainManager()
    
    func storePassphraseFor(address: String, password: String) throws {
        guard let password = password.data(using: .utf8) else {
            throw KeyChainError.wrapperError
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: address,
            kSecValueData as String: password
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            break
        default:
            throw KeyChainError.servicesError
        }
    }
    
    func getGenericPasswordFor(address: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: address,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeyChainError.itemNotFound
        }
        guard status == errSecSuccess else {
            throw KeyChainError.servicesError
        }
        
        guard let existingItem = item as? [String: Any],
              let valueData = existingItem[kSecValueData as String] as? Data,
              let value = String(data: valueData, encoding: .utf8) else {
                  throw KeyChainError.unableToConvertToString
              }
        
        return value
    }
}

private enum KeyChainError: Error {
    case wrapperError
    case servicesError
    case itemNotFound
    case unableToConvertToString
}
