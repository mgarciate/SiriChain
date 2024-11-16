//
//  SendPaymentIntent.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import AppIntents

struct SendPaymentIntent: AppIntent {
    
    static var title = LocalizedStringResource("Send a payment to:")
    static var description: IntentDescription? = "Send a payment to a selected contact using one of your wallet's tokens quickly. Choose the token and amount, and complete the transfer easily."
    
    @Parameter(title: "Contact")
    var contact: Contact
    @Parameter(title: "Coin")
    var token: NetworkToken
    
    func perform() async throws -> some IntentResult {
        let walletController = SiriChainWalletController(clientUrl: scrollSepoliaUrl)
        if token.type == .stable {
            let txHash = try await walletController.transfer(to: contact.address, amount: 0.01)
        } else {
            let txHash = try await walletController.transfer(to: contact.address, amount: 0.01)
        }
        return .result()
    }
}
