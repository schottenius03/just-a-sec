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
        self.usersCollection = db.collection("users")
    }
    
    // add or update
    func addOrUpdate(reminder: Reminder, for userId: String) async throws {
        let collection = usersCollection.document(userId).collection("reminders")
        
        if let reminderId = reminder.id {
            // Uppdatera befintligt dokument
            do {
                try await collection.document(reminderId).setData([
                    "name": reminder.name,
                    "time": reminder.time
                ], merge: true)
            } catch {
                throw JASError.reminderFirestoreError(error)
            }
        } else {
            // Skapa nytt dokument
            let data: [String: Any] = [
                "name": reminder.name,
                "time": reminder.time
            ]
            do {
                _ = try await collection.addDocument(data: data)
            } catch {
                throw JASError.reminderFirestoreError(error)
            }
        }
    }
    
    // delete
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
    
    // get all reminders
    func getAllReminders(for userId: String) async throws -> [Reminder] {
        do {
            let snapshot = try await usersCollection
                .document(userId)
                .collection("reminders")
                .getDocuments()
            
            return snapshot.documents.compactMap { doc in
                let data = doc.data()
                let name = data["name"] as? String ?? ""
                let time = data["time"] as? String ?? ""
                return Reminder(id: doc.documentID, name: name, time: time)
            }
        } catch {
            throw JASError.reminderFirestoreError(error)
        }
    }
}
