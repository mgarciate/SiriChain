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
