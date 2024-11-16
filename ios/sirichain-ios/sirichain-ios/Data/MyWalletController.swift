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

    init(clientUrl: URL) {
        // TODO: Change
        // This is just an example. EthereumKeyLocalStorage should not be used in production code
        let keyStorage = EthereumKeyLocalStorage()
        let privateKey = KeychainHelper.shared.retrieveKey(
            service: KeychainHelper.servicePrivateKey,
            account: KeychainHelper.account
        ) ?? ""
        let password = KeychainHelper.shared.retrieveKey(
            service: KeychainHelper.serviceKeystorePassword,
            account: KeychainHelper.account
        ) ?? ""
        account = try? EthereumAccount.importAccount(replacing: keyStorage, privateKey: privateKey, keystorePassword: password)
        // TODO: move to a configuration file
        client = EthereumHttpClient(url: clientUrl, network: .fromString(ScrollNetwork.sepolia.stringValue))
    }
    
    func getNonce() async throws -> Int {
        guard let account = account else {
            throw SiriChainWalletError.noAccount
        }
        let nonce = try await client.eth_getTransactionCount(address: account.address, block: .Latest)
        return nonce
    }
    
    func getGasPrice() async throws -> BigUInt {
        try await client.eth_gasPrice()
    }
    
    func estimateGas(ethereumTransaction: EthereumTransaction) async throws -> BigUInt {
        try await client.eth_estimateGas(ethereumTransaction)
    }
    
    func transfer(destinationAddress to: String, amount: Double) async throws {
        guard let account = account else {
            throw SiriChainWalletError.noAccount
        }
//        EthereumTransaction(from: nil, to: "0x3c1bd6b420448cf16a389c8b0115ccb3660bb854", value: BigUInt(1), data: nil, nonce: 2, gasPrice: gasPrice ?? BigUInt(9000000), gasLimit: BigUInt(30000), chainId: EthereumNetwork)
        let transaction = EthereumTransaction(from: account.address, to: <#T##EthereumAddress#>, value: <#T##BigUInt?#>, data: <#T##Data?#>, nonce: <#T##Int?#>, gasPrice: <#T##BigUInt?#>, gasLimit: <#T##BigUInt?#>, chainId: .fromString(ScrollNetwork.sepolia.intValue)
        try await erc20.
    }
}
