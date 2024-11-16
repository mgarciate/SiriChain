//
//  KeychainHelper.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import Foundation
import Security

class KeychainHelper: @unchecked Sendable {
    static let teamId = "ZR272F7CTF"
    static let accessGroup = "\(teamId).com.mgarciate.sirichain"
    // TODO: remove this static value
    static let service = "api-key"
    static let account = "Wallet1"
    
    static let shared = KeychainHelper()

    private init() {}

    func savePrivateKey(_ privateKey: String, service: String, account: String) -> Bool {
#if DEBUG
        print("savePrivateKey: \(privateKey)")
#endif
        let data = Data(privateKey.utf8)

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrAccessGroup: KeychainHelper.accessGroup,
            kSecValueData: data,
            kSecAttrSynchronizable: true,
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)  // Remove existing item if any
        let status = SecItemAdd(query as CFDictionary, nil)

        return status == errSecSuccess
    }

    func retrieveApiKey(service: String, account: String) -> String? {
#if DEBUG
        print("retrieveApiKey")
#endif
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrAccessGroup: KeychainHelper.accessGroup,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrSynchronizable: true,
        ] as [String: Any]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func deleteApiKey(service: String, account: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrAccessGroup: KeychainHelper.accessGroup,
            kSecAttrSynchronizable: true,
        ] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
