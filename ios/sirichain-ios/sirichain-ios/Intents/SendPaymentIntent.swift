//
//  SendPaymentIntent.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import AppIntents

struct SendPaymentIntent: AppIntent {
    
    static var title = LocalizedStringResource("Send Payment")
    static var description: IntentDescription? = "Send a payment to a selected contact using one of your wallet's tokens quickly. Choose the token and amount, and complete the transfer easily."
    
    @Parameter(title: "Select a Contact")
    var contact: Contact
    
    func perform() async throws -> some IntentResult {
        // TODO: do something on-chain
        return .result()
    }
}
