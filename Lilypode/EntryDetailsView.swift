//
//  EntryDetailsView.swift
//  Lilypode
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI
import SwiftData
import HealthKit

struct EntryDetailsView: View {
    @Environment(\.modelContext) var modelContext
    
    var entry: Entry
    
    let pasteboard = UIPasteboard.general
    
    @StateObject var healthKitManager = HealthKitManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                Text(entry.content)
                    .listRowBackground(
                        Color.clear
                    )
                    .listRowInsets(.init(top: 10, leading: 5, bottom: 10, trailing: 5))
                Section("State of Mind") {
                    Text("Predicted SOM")
                    Text("Actual SOM")
                    Button("add to HealthKit") {
                        
//                        let hkObject: HKObject = .init()
//                        
//                        healthKitManager.healthStore.save(hkObject) { success, e in
//                            if success {
//                                print("success")
//                            } else {
//                                print("error:", e ?? "some error")
//                            }
//                        }
                    }
                }
                .listRowBackground(Color.accentColor.opacity(0.1))
                Section {
                    HStack {
                        Button {
                            pasteboard.string = "\(entry.timestamp.formatted(date: .long, time: .omitted)): \(entry.content)"
                        } label: {
                            Label("Copy", systemImage: "document.on.document")
                                .labelStyle(VerticalLabel())
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        Button {
                            print("2")
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .labelStyle(VerticalLabel())
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        Button {
                            print("3")
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .labelStyle(VerticalLabel(color: Color("Red")))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            }
            .navigationTitle(entry.timestamp.formatted(date: .long, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, -10)
            .navigationWithAccent()
            .roundedFont()
        }
    }
}

struct VerticalLabel: LabelStyle {
    
    var color: Color = .accentColor
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                configuration.icon
                    .font(.title)
                    .padding(.bottom, 0.1)
                configuration.title
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundStyle(color)
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.2))
        .cornerRadius(7)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Entry.self, configurations: config)
    
    let entry = Entry(content: "HELP i just made the biggest mistake of my life i texted him first. no bc the AUDACITY i had??? someone call the police i need to be arrested. anyways he left me on read for 20 min and i already planned our breakup. might go feral. might delete my whole existence. stay tuned.")
    
    return EntryDetailsView(entry: entry)
        .modelContainer(container)
}
