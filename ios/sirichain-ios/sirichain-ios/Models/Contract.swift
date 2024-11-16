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
    
    init(id: String = UUID().uuidString, name: String, address: String, functions: [String]) {
        self.id = id
        self.name = name
        self.address = address
        self.functions = functions
    }
}

extension Contract {
    static var dummyData: [Contract] {
        [
            Contract(name: "Contract 1", address: "0x4Bfeed4Ff741aA38fdc43F57b80cc6FD4FcFEb0b", functions: ["eth_gasPrice"]),
            Contract(name: "Contract 2", address: "0xE84cFa4A82727DeB74C02Fc5CDdbdc68AD48c0aa", functions: ["eth_getTransactionCount", "eth_estimateGas"]),
            Contract(name: "Contract 3", address: "0x7c1e1cFC7869a4cFdCA54B4644EfAbCab19aE776", functions: ["eth_getBalance"]),
            Contract(name: "Contract 4", address: "0x62Bf7b5d80FAe8405B67Fb9eD4842C82Cb038a3E", functions: ["eth_getTransactionReceipt"])
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
