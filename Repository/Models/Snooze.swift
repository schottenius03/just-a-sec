//
//  Snooze.swift
//  JustASec
//
//  Created by Kailing Schottenius on 22/11/2025.
//

import Foundation
import FirebaseFirestore

struct Snooze: Codable {
    var id: String?        // Dokument-ID
    var name: String
    var minutes: Int
    
    // Initializer
    init(id: String? = nil, name: String, minutes: Int) {
        self.id = id
        self.name = name
        self.minutes = minutes
    }
}
