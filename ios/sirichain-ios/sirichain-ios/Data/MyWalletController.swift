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

struct ClaimReward: ABIFunction {
    static let name = "claimReward"
    let contract: EthereumAddress
    let from: EthereumAddress?
    let gasPrice: BigUInt?
    let gasLimit: BigUInt?
    
    public func encode(to encoder: ABIFunctionEncoder) throws {
    }
}

struct CheckBalance: ABIFunction {
    static let name = "checkBalance"
    let contract: EthereumAddress
    let from: EthereumAddress?
    let gasPrice: BigUInt?
    let gasLimit: BigUInt?
    
    public func encode(to encoder: ABIFunctionEncoder) throws {
    }
}

enum SiriChainWalletError: Error {
    case noAccount
}

public class SiriChainWalletController {
    private let etherInWei = pow(Double(10), 18)
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
        let nonce = try await getNonce()
        let gasPrice = try await client.eth_gasPrice()
        let to = await resolveAddress(destinationAddress)
        let transaction = EthereumTransaction(from: account.address, to: EthereumAddress(to), value: BigUInt(amount * etherInWei), data: nil, nonce: nonce, gasPrice: gasPrice, gasLimit: BigUInt(50000), chainId: ScrollNetwork.sepolia.intValue)
        let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
        return txHash
    }
    
    func transfer(to destinationAddress: String, amount: Double, token: NetworkToken) async throws -> String {
        guard let account = account else {
            throw SiriChainWalletError.noAccount
        }
        let gasPrice = try await client.eth_gasPrice()
        let to = await resolveAddress(destinationAddress)
        let function = Transfer(contract: EthereumAddress(token.address), from: account.address, to: EthereumAddress(to), value: BigUInt(amount * etherInWei), data: Data(), gasPrice: gasPrice, gasLimit: BigUInt(100000))
        let transaction = try function.transaction()
        let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
        return txHash
    }
    
    func balance() async throws -> BigUInt {
        guard let account = account else {
            throw SiriChainWalletError.noAccount
        }
        let gasPrice = try await client.eth_gasPrice()
        let function = ClaimReward(contract: EthereumAddress("0x6F9177CaA58a82ed3aE0491ededF4e6be8be5617"), from: account.address, gasPrice: gasPrice, gasLimit: BigUInt(100000))
        let transaction = try function.transaction()
        let data = try await client.eth_sendRawTransaction(transaction, withAccount: account)
        if let balanceHex = data as? String, let balance = BigUInt(hex: balanceHex) {
            return balance
        } else {
            throw EthereumClientError.noResultFound
        }
    }
    
    func claimReward() async throws -> String {
        guard let account = account else {
            throw SiriChainWalletError.noAccount
        }
        let gasPrice = try await client.eth_gasPrice()
        let function = ClaimReward(contract: EthereumAddress("0x6F9177CaA58a82ed3aE0491ededF4e6be8be5617"), from: account.address, gasPrice: gasPrice, gasLimit: BigUInt(100000))
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
