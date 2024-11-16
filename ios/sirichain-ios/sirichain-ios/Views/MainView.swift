//
//  MainView.swift
//  sirichain-ios
//
//  Created by mgarciate on 15/11/24.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var address: String = ""
    
    func reloadWallet() {
        let walletController = SiriChainWalletController(clientUrl: scrollSepoliaUrl)
        address = walletController.account?.address.asString() ?? ""
    }
}

struct MainView: View {
    @State var navigationPath = NavigationPath()
    @StateObject var viewModel = MainViewModel()
    @State private var isSettingsPresented = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                List {
                    NavigationLink {
                        ContactsView()
                    } label: {
                        ItemView(systemImage: "person.crop.circle.fill", title: "Contacts", subtitle: "Count:", value: 4)
                    }
                    NavigationLink {
                        ContractsView()
                    } label: {
                        ItemView(systemImage: "document.circle.fill", title: "Functions on-chain", subtitle: "Count:", value: 5)
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
                if !viewModel.address.isEmpty {
                    Text(viewModel.address)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(.red.opacity(0.8))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.red, lineWidth: 2)
                                .padding(.leading, 1)
                        )
                        .frame(height: 40)
                }
            }
        }
        .fullScreenCover(isPresented: $isSettingsPresented, onDismiss: {
            viewModel.reloadWallet()
        }) {
            SettingsView()
        }
        .onAppear {
            viewModel.reloadWallet()
        }
    }
}

#Preview {
    MainView()
}

struct ItemView: View {
    let systemImage: String
    let title: String
    let subtitle: String
    let value: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 245 / 255, green: 127 / 255, blue: 23 / 255))
                .shadow(radius: 5)
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                ZStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        HStack(alignment: .bottom, spacing: 5) {
                            Text(subtitle)
                                .font(.caption.italic())
                            Text("\(value)")
                                .font(.subheadline.bold())
                            Spacer()
                        }
                        .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
            .padding()
        }
    }
}
