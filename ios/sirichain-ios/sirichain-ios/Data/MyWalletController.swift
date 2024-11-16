//
//  MyWalletController.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import Foundation
import web3
import BigInt

enum SiriChainWalletError: Error {
    case noAccount
}

final class SiriChainWalletController {
    let account: EthereumAccount?
    let client: EthereumHttpClient

    init(keyStorage: EthereumSingleKeyStorageProtocol, clientUrl: URL) {
        // TODO: Change
        // This is just an example. EthereumKeyLocalStorage should not be used in production code
        let keyStorage = EthereumKeyLocalStorage()
        account = try? EthereumAccount.create(replacing: keyStorage, keystorePassword: "MY_PASSWORD")
        // TODO: move to a configuration file
        client = EthereumHttpClient(url: clientUrl, network: .fromString("84532"))
    }
    
    func getNonce() async throws -> Int {
        guard let account = account else {
            throw SiriChainWalletError.noAccount
        }
        let nonce = try await client.eth_getTransactionCount(address: account.address, block: .Latest)
        return nonce
    }
    
    func getGasPrice() async throws -> BigUInt {
        return try await client.eth_gasPrice()
    }
    
    func estimateGas(ethereumTransaction: EthereumTransaction) async throws -> BigUInt {
        return try await client.eth_estimateGas(ethereumTransaction)
    }
}
