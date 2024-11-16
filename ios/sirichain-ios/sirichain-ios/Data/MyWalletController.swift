//
//  MyWalletController.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import Foundation
import web3
import BigInt

struct Transfer: ABIFunction {
    static let name = "transfer"
    let contract: EthereumAddress
    let from: EthereumAddress?
    let to: EthereumAddress
    let value: BigUInt
    let data: Data
    let gasPrice: BigUInt?
    let gasLimit: BigUInt?
    
    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(to)
        try encoder.encode(value)
    }
}

enum SiriChainWalletError: Error {
    case noAccount
}

public class SiriChainWalletController {
    let account: EthereumAccount?
    let client: EthereumHttpClient
    let mainnetClient: EthereumHttpClient

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
        mainnetClient = EthereumHttpClient(url: mainnetUrl, network: .mainnet)
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
    
    func transfer(to destinationAddress: String, amount: Double) async throws -> String {
        guard let account = account else {
            throw SiriChainWalletError.noAccount
        }
//        EthereumTransaction(from: nil, to: "0x3c1bd6b420448cf16a389c8b0115ccb3660bb854", value: BigUInt(1), data: nil, nonce: 2, gasPrice: gasPrice ?? BigUInt(9000000), gasLimit: BigUInt(30000), chainId: EthereumNetwork)
        let nonce = try await getNonce()
        let gasPrice = try await client.eth_gasPrice()
        let to = await resolveAddress(destinationAddress)
        let transaction = EthereumTransaction(from: account.address, to: EthereumAddress(to), value: BigUInt(150000000000000), data: nil, nonce: nonce, gasPrice: gasPrice, gasLimit: BigUInt(50000), chainId: ScrollNetwork.sepolia.intValue)
        let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
        return txHash
    }
    
    func transfer(to destinationAddress: String, amount: Double, token: NetworkToken) async throws -> String {
        guard let account = account else {
            throw SiriChainWalletError.noAccount
        }
        let gasPrice = try await client.eth_gasPrice()
        let to = await resolveAddress(destinationAddress)
        let function = Transfer(contract: EthereumAddress(token.address), from: account.address, to: EthereumAddress(to), value: BigUInt(160000000000000), data: Data(), gasPrice: gasPrice, gasLimit: BigUInt(100000))
        let transaction = try function.transaction()
        let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
        return txHash
    }
    
    private func resolveAddress(_ address: String) async -> String {
        let nameService = EthereumNameService(client: mainnetClient)
        
        return (try? await nameService.resolve(
            ens: address,
            mode: .allowOffchainLookup
        ))?.asString() ?? address
    }
}
