//
//  StatisticsView.swift
//  Lilienne
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    let calendar = Calendar.current
    
    private var journaledRecently: Bool {
        calendar.isDateInToday(entries[0].timestamp) || calendar.isDateInYesterday(entries[0].timestamp)
    }
    
    var streak: Int {
        
        var _streak = 0
        
        if !entries.isEmpty && journaledRecently {
            var currentDate = calendar.isDateInToday(entries[0].timestamp) ? Date() : calendar.date(byAdding: .day, value: -1, to: Date())!
            
            for entry in entries {
                if calendar.isDate(entry.timestamp, inSameDayAs: currentDate) {
                    _streak += 1
                    currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
                }
            }
            
            return _streak
        }
        return _streak
    }
    
    var wordCount: Int {
        
        var _wordCount = 0
        
        for entry in entries {
            _wordCount += entry.content.split(separator: " ").count
        }
        
        return _wordCount
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    StatListItemView(labelText: "Streak", labelImage: "flame", valueText: "\(streak)")
                    StatListItemView(labelText: "Word Count", labelImage: "text.word.spacing", valueText: "\(wordCount)")
                }
                Section {
                    NavigationLink {
                        WordCloudView()
                    } label: {
                        Label("Word Cloud", systemImage: "cloud")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)
                            .labelStyle(CustomLabel(spacing: 10))
                    }
                    .listRowBackground(Color.accent.opacity(0.1))
                }
                Section("Trends") {
                    Text("I'm tired. Gimme a bit.")
                        .listRowBackground(Color.accent.opacity(0.1))
                }
            }
            .navigationTitle("Statistics")
            .navigationWithAccent()
            .roundedFont()
        }
    }
}

struct StatListItemView: View {
    
    var labelText: String
    var labelImage: String
    var valueText: String
    
    var body: some View {
        HStack {
            Label(labelText, systemImage: labelImage)
                .foregroundStyle(.accent)
                .fontWeight(.semibold)
                .labelStyle(CustomLabel(spacing: 10))
            Spacer()
            Text(valueText)
        }
        .listRowBackground(Color.accent.opacity(0.1))
    }
}

struct CustomLabel: LabelStyle {
    var spacing: Double = 10.0
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
            configuration.title
        }
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Entry.self, configurations: config)
    let calendar = Calendar.current
    
    let entries: [Entry] = K.entries
    entries.forEach(container.mainContext.insert)
    
    return StatisticsView()
        .modelContainer(container)
    
}
