//
//  SettingsView.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var privateKey: String
    
    init() {
        privateKey = KeychainHelper.shared.retrieveKey(
            service: KeychainHelper.servicePrivateKey,
            account: KeychainHelper.account
        ) ?? ""
    }
    
    func save() {
        _ = KeychainHelper.shared.saveKey(
            privateKey,
            service: KeychainHelper.servicePrivateKey,
            account: KeychainHelper.account
        )
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = SettingsViewModel()
    @State private var apikeyPopoverPresented = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    SecureView(titleKey: "WALLET PRIVATE KEY ⚠️", text: $viewModel.privateKey)
                    if viewModel.privateKey.isEmpty {
                        Text("Can be empty only for reading purposes.")
                            .foregroundStyle(.red)
                            .font(.caption.italic())
                    }
                }, header: {
                    HStack {
                        Text("Credentials")
                        Button {
                            apikeyPopoverPresented = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(Color.yellow)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundStyle(.blue)
                        .popover(isPresented: $apikeyPopoverPresented,
                                 attachmentAnchor: .point(.center),
                                 arrowEdge: .top) {
                            Text("\nExporting private keys from wallets is highly risky, exposing funds to potential theft through malware, phishing, and accidental leaks. Anyone choosing to export private keys does so at their own risk.\n")
                                .textCase(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                                .presentationCompactAdaptation(.none)
                        }
                    }
                })
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.save()
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
