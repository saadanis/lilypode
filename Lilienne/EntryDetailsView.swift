//
//  EntryDetailsView.swift
//  Lilienne
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI
import SwiftData

struct EntryDetailsView: View {
    @Environment(\.modelContext) var modelContext
    
    var entry: Entry
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(entry.content)
                        .listRowBackground(
                            Color.accentColor.opacity(0.1)
                        )
                }
                Section("State of Mind") {
                    Text("Predicted SOM")
                    Text("Actual SOM")
                }
            }
            .navigationTitle(entry.timestamp.formatted(date: .long, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
            .navigationWithAccent()
            .roundedFont()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Entry.self, configurations: config)
    
    let entry = Entry(content: "HELP i just made the biggest mistake of my life i texted him first. no bc the AUDACITY i had??? someone call the police i need to be arrested. anyways he left me on read for 20 min and i already planned our breakup. might go feral. might delete my whole existence. stay tuned.")
    
    return EntryDetailsView(entry: entry)
        .modelContainer(container)
}
