//
//  WriteDataOnChainIntent.swift
//  sirichain-ios
//
//  Created by mgarciate on 17/11/24.
//


import AppIntents

struct WriteDataOnChainIntent: AppIntent {
    
    static var title = LocalizedStringResource("Write data on-chain")
    static var description: IntentDescription? = "An iOS AppIntent that allows users to select a smart contract and execute specific write functions, enabling interaction with the blockchain directly from the app."
    
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
