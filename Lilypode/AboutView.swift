//
//  AboutView.swift
//  Lilypode
//
//  Created by Saad Anis on 24/02/2025.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                HStack {
//                    Spacer()
                    Image("Lily")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(15)
                    VStack(alignment: .leading) {
                        Text("Lilypode")
                            .font(.headline)
                            .roundedFont()
                        Text("By Saad Anis")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .roundedFont()
                        Text("Version \(AppVersionProvider.appVersion())")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .roundedFont()
                    }
                    .padding(.leading, 8)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                Text("A minimal, time-boxed journaling app that helps you write without overthinking. Set a timer, type until it runs out, and build a daily habit. Track streaks, moods, and insights with Apple Health. Lily, your playful eight-legged companion, keeps you motivated with witty encouragement.")
                .listRowBackground(Color.accent.opacity(0.1))
            }
        }
        .listRowSpacing(1)
        .navigationTitle("About")
        .navigationWithAccent()
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
