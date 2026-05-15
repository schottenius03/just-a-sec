//
//  Snooze.swift
//  JustASec
//
//  Created by Kailing Schottenius on 30/11/2025.
//

import Foundation
import FirebaseFirestore

struct Snooze: Codable {
    @DocumentID var id: String?
    var name: String
    var time: String // inc AM/PM
}
