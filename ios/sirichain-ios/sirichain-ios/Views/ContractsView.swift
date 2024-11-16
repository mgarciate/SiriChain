//
//  ContractsView.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import SwiftUI

struct ContractsView: View {
    //    @Query var contracts: [Contract]
    @State var contracts: [Contract] = Contract.dummyData
    
    var body: some View {
        NavigationStack {
            ZStack {
                if contracts.isEmpty {
                    ContentUnavailableView("No contracts", systemImage: "doc.text", description: Text("No contracts available. Tap the + button in the top-right corner to add a new contract."))
                } else {
                    List {
                        ForEach(contracts) { contract in
                            NavigationLink {
                                Text(contract.name)
                            } label: {
                                Text(contract.name)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Contracts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // TODO: Create a new contract
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear() {
            if contracts.isEmpty {
                // TODO: Insert default values
            }
        }
    }
}

#Preview {
    ContractsView()
}
