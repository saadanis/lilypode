//
//  SettingsView.swift
//  Lilienne
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI
import SwiftData
import HealthKit
import HealthKitUI

struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    @StateObject var healthKitManager = HealthKitManager.shared
    
    @State var isAuthenticated = false
    @State var isTriggered = false
    
    @State var currentIconName = UIApplication.shared.alternateIconName
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    DurationGridView()
                        .listRowBackground(Color.accent.opacity(0.1))
                } header: {
                    Text("Timer Duration")
                } footer: {
                    Text("I'll add custom times soon, dw.")
                }
                Section {
                    Button {
                        if HKHealthStore.isHealthDataAvailable() {
                            isTriggered.toggle()
                        }
                    } label: {
                        Label("Authorize Apple Health", systemImage: "heart")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)
                            .labelStyle(CustomLabel())
                    }
                    .listRowBackground(Color.accentColor.opacity(0.1))
                    .disabled(!isAuthenticated)
                    .healthDataAccessRequest(
                        store: healthKitManager.healthStore,
                        shareTypes: [HKQuantityType.stateOfMindType()],
                        readTypes: [HKQuantityType.stateOfMindType()],
                        trigger: isTriggered,
                        completion: { result in
                            switch result {
                            case .success(_):
                                isAuthenticated = true
                            case .failure(let error):
                                fatalError("*** An error occurred while requesting authentication: \(error) ***")
                            }
                        })
                }
                Section {
                    Button {
                        withAnimation {
                            for entry in entries {
                                modelContext.delete(entry)
                            }
                            let testEntries: [Entry] = K.entries
                            testEntries.forEach(modelContext.insert)
                        }
                    } label: {
                        Label("Replace with Test Entries", systemImage: "eyes")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)
                            .labelStyle(CustomLabel())
                    }
                    .listRowBackground(Color.accentColor.opacity(0.1))
                    Button(role: .destructive) {
                        withAnimation {
                            for entry in entries {
                                modelContext.delete(entry)
                            }
                        }
                    } label: {
                        Label("Delete All \(entries.count) Entries", systemImage: "trash")
                            .labelStyle(CustomLabel(spacing: 10))
                            .foregroundStyle(Color("Red"))
                            .fontWeight(.semibold)
                    }
                    .listRowBackground(Color("Red").opacity(0.1))
                } header: {
                    Text("Beta Testing Options")
                } footer: {
                    Text("There be no warning alerts, boy. You click it and it happens, mu ha ha ha.")
                }
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "info.circle")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)
                            .labelStyle(CustomLabel())
                    }
                    .listRowBackground(Color.accentColor.opacity(0.1))
                }
            }
            .navigationTitle("Settings")
            .navigationWithAccent()
            .roundedFont()
        }
    }
}


struct DurationGridView: View {
    
    @State var timerDuration = UserDefaults.standard.integer(forKey: "timerDuration")
    
    let data = [
        10, 15, 30, 60, 90, 120,
    ]
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(data, id: \.self) { item in
                    DurationGridItemView(text: "\(item)s", time: item, timerDuration: timerDuration) {
                        withAnimation(.snappy(duration: 0.4)) {
                            timerDuration = item
                        }
                        print("what \(item)")
                        updateDuration(item)
                        UIApplication.shared.setAlternateIconName("AppIcon") { (error) in
                            if let error = error {
                                print("Failed request to update the app’s icon: \(error)")
                            }
                        }
                    }
                }
                DurationGridItemView(text: "", symbol: "ellipsis", time: 0, timerDuration: timerDuration) {
                    
                }
            }
        }
    }
    
    func updateDuration(_ duration: Int) {
        UserDefaults.standard.set(duration, forKey: "timerDuration")
    }
}

struct DurationGridItemView: View {
    
    var text: String
    var symbol: String?
    var time: Int
    var timerDuration: Int
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if let symbol = symbol {
                Image(systemName: symbol)
            } else {
                Text(text)
            }
        }
        .buttonStyle(.plain)
        .frame(width: 50, height: 50)
        .background(Color.accentColor.opacity(
            time == timerDuration ? 0.3 : 0.1
        ))
        .foregroundStyle(Color.accentColor)
        .font(.headline)
        .cornerRadius(8)
        .overlay(
            time == timerDuration ?
            RoundedRectangle(cornerRadius: 8)
                .stroke(.accent, lineWidth: 3) :
                nil
        )
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Entry.self, configurations: config)
    let calendar = Calendar.current
    
    let entries: [Entry] = K.entries
    entries.forEach(container.mainContext.insert)
    
    return SettingsView()
        .modelContainer(container)
}
