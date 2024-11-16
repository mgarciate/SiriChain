//
//  ScrollNetwork.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import Foundation

public enum ScrollNetwork: Equatable, Decodable {
    case mainnet
    case sepolia
    
    public static func fromString(_ networkId: String) -> ScrollNetwork {
        switch networkId {
        case "534352":
            return .mainnet
        case "534351":
            return .sepolia
        default:
            return .sepolia
        }
    }

    public var stringValue: String {
        switch self {
        case .mainnet:
            return "534352"
        case .sepolia:
            return "534351"
        }
    }

    public var intValue: Int {
        switch self {
        case .mainnet:
            return 534352
        case .sepolia:
            return 534351
        }
    }
}

public func == (lhs: ScrollNetwork, rhs: ScrollNetwork) -> Bool {
    lhs.stringValue == rhs.stringValue
}
