//
//  JASError.swift
//  JustASec
//
//  Created by Kailing Schottenius on 21/11/2025.
//

import Foundation

enum JASError: Error, LocalizedError {
    
    // user errors
    case userIdNotFound
    case firestoreError(Error)
    case encodingError(Error)
    
    // reminder errors
    case reminderIdNotFound
    case reminderEncodingError(Error)
    case reminderFirestoreError(Error)
    
    // snooze errors
    case snoozeIdNotFound
    case snoozeEncodingError(Error)
    case snoozeFirestoreError(Error)
    
    // description
    var errorDescription: String? {
        switch self {
            
        // User
        case .userIdNotFound:
            return "User ID not found"
        case .firestoreError(let error):
            return "Firestore operation failed: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode User object: \(error.localizedDescription)"
            
        // Reminder
        case .reminderIdNotFound:
            return "Reminder ID not found"
        case .reminderEncodingError(let error):
            return "Failed to encode Reminder object: \(error.localizedDescription)"
        case .reminderFirestoreError(let error):
            return "Firestore operation failed for Reminder: \(error.localizedDescription)"
        
        // Snooze
        case .snoozeIdNotFound:
            return "Snooze ID not found"
        case .snoozeEncodingError(let error):
            return "Failed to encode Snooze object: \(error.localizedDescription)"
        case .snoozeFirestoreError(let error):
            return "Firestore operation failed for Snooze: \(error.localizedDescription)"
        }
    }
}
