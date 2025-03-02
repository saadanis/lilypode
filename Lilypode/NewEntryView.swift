//
//  NewEntryView.swift
//  Lilypode
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    private var initialTime = UserDefaults.standard.integer(forKey: "timerDuration")
    
//    @State private var timeRemaining = UserDefaults.standard.integer(forKey: "timerDuration")
    @State private var timeRemaining = 2
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isPulsing = false
    
    @State private var entryContent = "ugh. today was literally the worst. like. why do teachers act like i don’t have a life outside of school??? ms. davis had the AUDACITY to assign a five-page essay DUE TOMORROW like be so fr. do i look like someone who has time for that?? also my mom is literally so annoying. she was like “you need to clean your room” like girl WHY do you care??? you don’t even come in here. it’s MY space. let me be messy in PEACE. anyway. i think i’m gonna fail math. which is whatever tbh. like who even uses algebra in real life."
    @FocusState private var isFocused: Bool
    
    private var backgroundOpacity: Double {
        let a = 10.0
        let b = 0.0
        let x = 0.2
        let y = 0.5
        
        let m = (y-x)/(b-a)
        let c = x - m*a
        
        return m*Double(timeRemaining) + c
    }
    
    @State private var isTimerVisible = false
    
    @State private var timerScale: CGFloat = 1
    
    @State private var newEntry: Entry? = nil
    
    
    var body: some View {
        NavigationStack {
            if newEntry == nil {
                ZStack {
                    VStack {
                        TextEditor(text: $entryContent)
                            .disabled(timeRemaining <= -1)
                            .focused($isFocused, equals: true)
                            .scrollContentBackground(.hidden)
                            .contentMargins(.horizontal, 15, for: .scrollContent)
                            .contentMargins(.bottom, 50, for: .scrollContent)
                    }
                }
                .overlay {
                    if isTimerVisible {
                        VStack {
                            Spacer()
                            if timeRemaining > 0 {
                                Text("\(formatTime(timeRemaining))")
                                    .roundedFont()
                                    .fontWeight(.medium)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                    .background(Color.accentColor.opacity(0.4))
                                    .background(Material.thin)
                                    .cornerRadius(15)
                                    .shadow(color: .accentColor.opacity(0.4), radius: 5)
                                    .scaleEffect(timerScale)
                                    .padding(.bottom)
                            } else {
                                Label("Timer Complete", systemImage: "checkmark.circle")
                                    .roundedFont()
                                    .labelStyle(CustomLabel(spacing: 5))
                                    .fontWeight(.medium)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                    .foregroundStyle(.primary)
                                    .background(Color("Green").opacity(0.7))
                                    .background(Material.thin)
                                    .cornerRadius(15)
                                    .shadow(color: Color("Green").opacity(0.4), radius: 5)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
                .navigationTitle("New Entry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            addEntry()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Delete") {
                            dismiss()
                        }
                        .foregroundStyle(Color("Red"))
                        .disabled(timeRemaining <= 0)
                    }
                }
                .background(.accent.opacity(0.2))
                .sensoryFeedback(.increase, trigger: timeRemaining, condition: { oldValue, newValue in
                    newValue < 10 && newValue > 0
                })
                .sensoryFeedback(.success, trigger: timeRemaining == 0)
            } else {
                EntryDetailsView(entry: newEntry!)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                dismiss()
                            }
                        }
                    }
            }
        }
        .onAppear {
            isFocused = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    isTimerVisible = true
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > -2 {
                withAnimation {
                    timeRemaining -= 1
                }
                if timeRemaining < 10 {
                    
                    //                    withAnimation(.easeInOut(duration: 0.2).repeatForever(autoreverses: false)) {
                    //                        isPulsing.toggle()
                    //                    }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        timerScale = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.bouncy(duration: 0.4, extraBounce: 0.4)) {
                            timerScale = 1.0
                        }
                    }
                }
            } else {
                if newEntry == nil {
                    withAnimation {
                        isTimerVisible = false
                    }
                    addEntry()
                }
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                isActive = true
            } else {
                isActive = false
            }
        }
    }
    
    private func addEntry() {
        
        entryContent = entryContent.trimmingCharacters(in: .whitespacesAndNewlines)
        if entryContent.isEmpty { return }
        newEntry = Entry(content: entryContent)
        modelContext.insert(newEntry!)
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    NewEntryView()
}
