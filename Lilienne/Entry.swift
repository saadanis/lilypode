//
//  Item.swift
//  Lilienne
//
//  Created by Saad Anis on 22/02/2025.
//

import Foundation
import SwiftData

@Model
final class Entry {
    var timestamp: Date = Date.now
    var content: String = ""
    
    init(content: String) {
        self.timestamp = Date()
        self.content = content
    }
    
    init(timestamp: Date, content: String) {
        self.timestamp = timestamp
        self.content = content
    }
}
