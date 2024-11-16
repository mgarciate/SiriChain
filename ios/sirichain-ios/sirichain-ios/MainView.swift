//
//  MainView.swift
//  sirichain-ios
//
//  Created by mgarciate on 15/11/24.
//

import SwiftUI

struct MainView: View {
    @State var navigationPath = NavigationPath()
    @State private var isSettingsPresented = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                NavigationLink {
                    ContactsView()
                } label: {
                    Label("Contacts", systemImage: "person.2")
                }
                NavigationLink {
                    ContractsView()
                } label: {
                    Label("Contracts", systemImage: "doc.text")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Siri Chain")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isSettingsPresented = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isSettingsPresented, onDismiss: {
            // TODO: do something?
        }) {
            SettingsView()
        }
    }
}

#Preview {
    MainView()
}
