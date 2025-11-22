//
//  Reminder.swift
//  JustASec
//
//  Created by Kailing Schottenius on 22/11/2025.
//

import Foundation
import FirebaseFirestore

struct Reminder: Codable {
    var id: String?      // Dokument-ID
    var name: String
    var time: String     // HH:mm

    // Initializer
    init(id: String? = nil, name: String, time: String) {
        self.id = id
        self.name = name
        self.time = time
    }
}
