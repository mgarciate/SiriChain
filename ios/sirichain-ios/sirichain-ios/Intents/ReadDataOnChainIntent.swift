//
//  ReadDataOnChainIntent.swift
//  sirichain-ios
//
//  Created by mgarciate on 17/11/24.
//

import AppIntents

struct ReadDataOnChainIntent: AppIntent {
    
    static var title = LocalizedStringResource("Read data on-chain")
    static var description: IntentDescription? = "A simple AppIntent for iOS that lets users select a contract and read from a specific function on it."
    
    @Parameter(title: "Contract")
    var contract: Contract
    
    @Parameter(title: "Function")
    var function: String
    
    func perform() async throws -> some IntentResult {
        let walletController = SiriChainWalletController(clientUrl: scrollSepoliaUrl)
//        if token.type == .stable {
//            let txHash = try await walletController.transfer(to: contact.address, amount: amount, token: token)
//        } else {
//            let txHash = try await walletController.transfer(to: contact.address, amount: amount)
//        }
        return .result()
    }
}
