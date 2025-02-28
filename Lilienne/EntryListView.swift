//
//  EntryListView.swift
//  Lilienne
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI
import SwiftData

struct EntryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    @State private var newEntryViewIsPresented = false
    @State private var searchText = ""
    @State private var searchableIsPresented = false
    
    private var journaledToday: Bool {
        !entries.isEmpty && calendar.isDateInToday(entries[0].timestamp)
    }
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text(journaledToday ?
                             "You have already journaled today." :
                                "You have not journaled today."
                        )
                        .roundedFont()
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                        Button {
                            newEntryViewIsPresented.toggle()
                        } label: {
                            HStack {
                                Label(journaledToday ?
                                      "Journal Complete" :
                                        "Start Journaling",
                                      systemImage: journaledToday ?
                                      "sparkles" :
                                        "square.and.pencil")
                                .labelStyle(CustomLabel(spacing: 10))
                                .font(.headline)
                                .roundedFont()
                                
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.accent)
                        .disabled(journaledToday)
                    }
                    Spacer()
                }
                .listRowBackground(
                    Color.clear
                )
                Section {
                    ForEach(searchResults) { entry in
                        NavigationLink {
                            EntryDetailsView(entry: entry)
                        } label: {
                            EntryListItemView(entry: entry, dateFormatter: dateFormatter)
                        }
                        .listRowBackground(
                            Color.accentColor.opacity(0.1)
                        )
                    }
                    .onDelete(perform: deleteEntries)
                }
            }
            .listRowSpacing(15)
            .listSectionSpacing(15)
            //            .searchable(text: $searchText, isPresented: $searchableIsPresented)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("Entries")
            .navigationWithAccent()
        }
        .fullScreenCover(isPresented: $newEntryViewIsPresented, content: NewEntryView.init)
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

struct EntryListItemView: View {
    
    var entry: Entry
    var dateFormatter: DateFormatter
    
    var date: String {
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: entry.timestamp)
    }
    
    var day: String {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: entry.timestamp)
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(date)
                    .font(.system(size: 50, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(stops: [
                            .init(color: .accent.opacity(0.6), location: 0),
                            .init(color: .accent.opacity(0), location: 1)
                        ], startPoint: .topLeading, endPoint: .trailing)
//                        .accent.opacity(0.2)
                    )
                    .scaleEffect(2.5) // Adjust scale to control visibility
                    .rotationEffect(.degrees(-10))
                    .blur(radius: 5)
                    .padding(.leading, -10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading) {
                Text(day.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                    .roundedFont()
                Text(entry.timestamp.formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .roundedFont()
                Text(entry.content)
                    .lineLimit(2...4)
                    .roundedFont()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading)
        }
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Entry.self, configurations: config)
    
    let entries: [Entry] = K.entries
    entries.forEach(container.mainContext.insert)
    
    return EntryListView()
        .modelContainer(container)
}
