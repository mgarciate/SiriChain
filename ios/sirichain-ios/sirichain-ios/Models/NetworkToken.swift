//
//  NetworkToken.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import Foundation
import AppIntents

enum TokenType {
    case currency, stable
}

final class NetworkToken: Identifiable {
    var id = UUID().uuidString
    var name: String
    var symbol: String
    var address: String
    var type: TokenType
    
    init(id: String, name: String, symbol: String, address: String, type: TokenType) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.address = address
        self.type = type
    }
}

extension NetworkToken {
    static var all: [NetworkToken] {
        [
            NetworkToken(id: "eth", name: "Ether", symbol: "ETH", address: "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE", type: .currency),
            NetworkToken(id: "dai", name: "Dai", symbol: "DAI", address: "0x4de50dfb5cf527c4fbf577e95b7c9862830cef39", type: .stable),
            NetworkToken(id: "tether", name: "Tether", symbol: "USDT", address: "0x34238bcb8d21d0ba2d8652923847e56ea6b2816b", type: .stable),
            NetworkToken(id: "usdc", name: "USDC", symbol: "USDC", address: "0xedebfb8e05ed6eccb2e41f5edda5df7b317676e4", type: .stable),
        ]
    }
}

extension NetworkToken: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation  = "Coin"
    var displayRepresentation: DisplayRepresentation {
        .init(title: LocalizedStringResource(stringLiteral: name))
    }
    static var defaultQuery = NetworkTokenQuery()
}

struct NetworkTokenQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [NetworkToken] {
        let tokens = NetworkToken.all.filter { networkToken in
            identifiers.contains { identifier in
                networkToken.name.lowercased() == identifier.lowercased()
            }
        }
        return tokens
    }
    
    func suggestedEntities() async throws -> [NetworkToken] {
        NetworkToken.all
    }
}
