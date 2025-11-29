//
//  Reminder.swift
//  JustASec
//
//  Created by Kailing Schottenius on 22/11/2025.
//

import Foundation
import FirebaseFirestore

struct Reminder: Codable {
    @DocumentID var id: String?
    var name: String
    var time: String // inc AM/PM
    var isActive: Bool = true
}
