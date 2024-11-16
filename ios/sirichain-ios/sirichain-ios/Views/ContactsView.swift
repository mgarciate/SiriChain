//
//  ContactsView.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import SwiftUI
import SwiftData

struct ContactsView: View {
//    @Query var contacts: [Contact]
    @State var contacts: [Contact] = Contact.dummyData
    
    var body: some View {
        NavigationStack {
            ZStack {
                if contacts.isEmpty {
                    ContentUnavailableView("No contacts", systemImage: "person.2", description: Text("No contacts available. Tap the + button in the top-right corner to add a new contact."))
                } else {
                    List {
                        ForEach(contacts) { contact in
                            NavigationLink {
                                Text(contact.name)
                            } label: {
                                Text(contact.name)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // TODO: Create a new contact
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear() {
            if contacts.isEmpty {
                // TODO: Insert default values
            }
        }
    }
}

#Preview {
    ContactsView()
}
