//
//  WordCloudView.swift
//  Lilienne
//
//  Created by Saad Anis on 23/02/2025.
//

import SwiftUI
import SwiftData

struct WordCloudView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    let stopWords = ["i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now"]
    
    var words: [String: Int] {
        
        var _words: [String] = []
        
        for entry in entries {
            let entryComponents = entry.content.components(separatedBy: " ").map {
                $0.trimmingCharacters(in: .punctuationCharacters)
            }
            _words.append(contentsOf: entryComponents.filter{
                !stopWords.contains($0)
            })
        }
        
        return _words.reduce(into: [:]) { counts, word in
            counts[word, default: 0] += 1
        }
    }
    
    var largestValue: Int {
        words.values.max()!
    }
    
    var body: some View {
        List {
            Section {
                ForEach(words.sorted(by: { $0.value > $1.value }), id: \.key) { word, count in
                    HStack {
                        Text(word)
                            .font(.system(size: CGFloat(mappedSize(size: count, maximum: largestValue))))
                        Spacer()
                        Text("\(count)")
                    }
                }
                .listRowBackground(Color.accent.opacity(0.1))
            } header: {
                Text("this is hard, man. I'll get back to it.")
            }
        }
        .navigationTitle("Word Cloud")
        .navigationWithAccent()
    }
    
    func mappedSize(size: Int, maximum: Int) -> CGFloat {
        
        let mappedBig = 50
        let mappedSmall = 16
        
        return CGFloat(mappedSmall + (size - 1) * (mappedBig - mappedSmall) / (maximum - 1))
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Entry.self, configurations: config)
    let calendar = Calendar.current
    
    let entries: [Entry] = K.entries
    entries.forEach(container.mainContext.insert)
    
    return WordCloudView()
        .modelContainer(container)
}
