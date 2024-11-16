//
//  Contact.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import Foundation
import SwiftData
import AppIntents

@Model
final class Contact: Identifiable {
    var id = UUID().uuidString
    var name: String = ""
    var address: String = ""
    
    init(id: String, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
}

extension Contact {
    static var dummyData: [Contact] {
        [
            Contact(id: "id1", name: "George", address: "mgarciate.eth"),
            Contact(id: "id2", name: "Alice", address: "0xE84cFa4A82727DeB74C02Fc5CDdbdc68AD48c0aa"),
            Contact(id: "id3", name: "Emily", address: "0x7c1e1cFC7869a4cFdCA54B4644EfAbCab19aE776"),
            Contact(id: "id4", name: "Bob", address: "0x62Bf7b5d80FAe8405B67Fb9eD4842C82Cb038a3E")
        ]
    }
}

extension Contact: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation  = "Contact"
    var displayRepresentation: DisplayRepresentation {
        .init(title: LocalizedStringResource(stringLiteral: name))
    }
    static var defaultQuery = ContactQuery()
}

struct ContactQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [Contact] {
        Contact.dummyData.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [Contact] {
        Contact.dummyData
    }
}
