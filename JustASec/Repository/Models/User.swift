//
//  User.swift
//  JustASec
//
//  Created by Kailing Schottenius on 21/11/2025.
//

import Foundation
import FirebaseFirestore


struct User : Codable { // help identify PK
    
    @DocumentID var id: String? // optional - indicate PK
    var email: String
    var memberSince: Date! // optional
    
    // initalizer
    init(id: String, email: String, memberSince: Date!) {
        self.id = id
        self.email = email
        self.memberSince = memberSince
    }
    
    // no memberSince
    init(id: String, email: String) {
        self.id = id
        self.email = email
    }
    
    
}
