//
//  Contract.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import Foundation
import SwiftData
import AppIntents

@Model
final class Contract: Identifiable {
    var id = UUID().uuidString
    var name: String = ""
    var address: String = ""
    var functions: [String] = []
    
    init(id: String, name: String, address: String, functions: [String]) {
        self.id = id
        self.name = name
        self.address = address
        self.functions = functions
    }
}

extension Contract {
    static var dummyData: [Contract] {
        [
            Contract(id: "contract1", name: "READ Siri Chain Game", address: "0x6F9177CaA58a82ed3aE0491ededF4e6be8be5617", functions: ["checkBalance"]),
            Contract(id: "contract2", name: "WRITE Siri Chain Game", address: "0x6F9177CaA58a82ed3aE0491ededF4e6be8be5617", functions: ["claimReward"]),
            Contract(id: "contract3", name: "Contract 3", address: "0x7c1e1cFC7869a4cFdCA54B4644EfAbCab19aE776", functions: ["eth_getTransactionCount", "eth_estimateGas"]),
            Contract(id: "contract4", name: "Contract 4", address: "0x62Bf7b5d80FAe8405B67Fb9eD4842C82Cb038a3E", functions: ["eth_getTransactionReceipt"])
        ]
    }
}

extension Contract: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation  = "Contract"
    var displayRepresentation: DisplayRepresentation {
        .init(title: LocalizedStringResource(stringLiteral: name))
    }
    static var defaultQuery = ContractQuery()
}

struct ContractQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [Contract] {
        Contract.dummyData
    }
    
    func suggestedEntities() async throws -> [Contract] {
        Contract.dummyData
    }
}
