//
//  ContentView.swift
//  Lilienne
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI
import SwiftData
import HealthKit


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    @State private var newEntryViewIsPresented = false
    @State private var searchText = ""
    
    var body: some View {
        TabView {
            Tab("Entries", systemImage: "rectangle.grid.1x2") {
                EntryListView()
                    .toolbarBackground(.accent.opacity(0.2), for: .tabBar)
            }
            Tab("Statistics", systemImage: "chart.bar.xaxis") {
                StatisticsView()
                    .toolbarBackground(.accent.opacity(0.2), for: .tabBar)
            }
            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
                    .toolbarBackground(.accent.opacity(0.2), for: .tabBar)
            }
        }
    }
    
    var searchResults: [Entry] {
        if searchText.isEmpty {
            return entries
        } else {
            return entries.filter {
                $0.content.lowercased().contains(searchText.lowercased())
            }
        }
    }

    private func addEntry() {
        withAnimation {
            let newEntry = Entry(content: "")
            modelContext.insert(newEntry)
        }
    }

    private func deleteEntries(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(entries[index])
            }
        }
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Entry.self, configurations: config)
    
    let entries: [Entry] = K.entries
    entries.forEach(container.mainContext.insert)
    
    return ContentView()
        .modelContainer(container)
}
