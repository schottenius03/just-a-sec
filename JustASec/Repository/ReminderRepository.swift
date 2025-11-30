
//
//  ReminderRepository.swift
//  JustASec
//
//  Created by Kailing Schottenius on 22/11/2025.
//

import Foundation
import FirebaseFirestore

class ReminderRepository {

    static let sharedReminderRepository = ReminderRepository()
    private let usersCollection: CollectionReference
    
    // Firestore
    init() {
        let db = Firestore.firestore()
        self.usersCollection = db.collection("users") // root
    }
    
    // Add or update reminder
    func addOrUpdate(reminder: Reminder, for userId: String) async throws {
        let collection = usersCollection.document(userId).collection("reminders")
        
        // data to store in Firestore
        let data: [String: Any] = [
            "name": reminder.name,
            "time": reminder.time,
            "isActive": reminder.isActive
        ]
        
        // check selected reminder 
        if let reminderId = reminder.id {
            // update
            do {
                try await collection.document(reminderId).setData(data, merge: true)
            } catch {
                throw JASError.reminderFirestoreError(error)
            }
        } else {
            // new
            do {
                _ = try await collection.addDocument(data: data)
            } catch {
                throw JASError.reminderFirestoreError(error)
            }
        }
    }
    
    // MARK: Delete reminder
    func deleteReminder(for userId: String, reminderId: String) async throws {
        do {
            try await usersCollection
                .document(userId)
                .collection("reminders")
                .document(reminderId)
                .delete()
        } catch {
            throw JASError.reminderFirestoreError(error)
        }
    }
    
    func getAllRemindersByUser(userId: String, completion: @escaping ([Reminder]) -> ()) {
        let remindersRef = usersCollection
            .document(userId)
            .collection("reminders")
        
        remindersRef.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print("Firebase listener error for reminders: \(error!.localizedDescription)")
                completion([])
                return
            }
            
            guard let snapshot = snapshot else {
                completion([])
                return
            }
            
            var decodedReminders: [Reminder] = []
            
            for document in snapshot.documents {
                do {
                    let reminder = try document.data(as: Reminder.self)
                    decodedReminders.append(reminder)
                } catch {
                    print("Error decoding document \(document.documentID) into Reminder: \(error.localizedDescription)")
                }
            }
            completion(decodedReminders)
        }
    }
}
