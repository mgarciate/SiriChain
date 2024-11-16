//
//  KeychainHelper.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import Foundation
import Security

class KeychainHelper: @unchecked Sendable {
    static let teamId = "M3XA3ETRDV"
    static let accessGroup = "\(teamId).com.mgarciate.sirichain"
    // TODO: remove this static value
    static let servicePrivateKey = "privatekey"
    static let serviceKeystorePassword = "keystorepassword"
    static let account = "Wallet1"
    
    static let shared = KeychainHelper()

    private init() {}

    func saveKey(_ privateKey: String, service: String, account: String) -> Bool {
#if DEBUG
        print("saveKey: \(service)")
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

    func retrieveKey(service: String, account: String) -> String? {
#if DEBUG
        print("retrieveKey: \(service)")
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
