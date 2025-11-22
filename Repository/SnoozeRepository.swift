//
//  SnoozeRepository.swift
//  JustASec
//
//  Created by Kailing Schottenius on 22/11/2025.
//

//
//  SnoozeRepository.swift
//  JustASec
//

import Foundation
import FirebaseFirestore

class SnoozeRepository {
    
    static let sharedSnoozeRepository = SnoozeRepository()
    private let usersCollection: CollectionReference
    
    // instance
    init() {
        let db = Firestore.firestore()
        self.usersCollection = db.collection("snoozes")
    }
    
    // add or update
    func addOrUpdate(snooze: Snooze, for userId: String) async throws {
        let collection = usersCollection.document(userId).collection("snoozes")
        
        if let snoozeId = snooze.id {
            // Uppdatera befintligt dokument
            do {
                try await collection.document(snoozeId).setData([
                    "name": snooze.name,
                    "minutes": snooze.minutes
                ], merge: true)
            } catch {
                throw JASError.snoozeFirestoreError(error)
            }
        } else {
            // Skapa nytt dokument
            let data: [String: Any] = [
                "name": snooze.name,
                "minutes": snooze.minutes
            ]
            do {
                _ = try await collection.addDocument(data: data)
            } catch {
                throw JASError.snoozeFirestoreError(error)
            }
        }
    }
    
    // delete
    func deleteSnooze(for userId: String, snoozeId: String) async throws {
        do {
            try await usersCollection
                .document(userId)
                .collection("snoozes")
                .document(snoozeId)
                .delete()
        } catch {
            throw JASError.snoozeFirestoreError(error)
        }
    }
    
    // get all snoozes
    func getAllSnoozes(for userId: String) async throws -> [Snooze] {
        do {
            let snapshot = try await usersCollection
                .document(userId)
                .collection("snoozes")
                .getDocuments()
            
            return snapshot.documents.compactMap { doc in
                let data = doc.data()
                let name = data["name"] as? String ?? ""
                let minutes = data["minutes"] as? Int ?? 0
                return Snooze(id: doc.documentID, name: name, minutes: minutes)
            }
        } catch {
            throw JASError.snoozeFirestoreError(error)
        }
    }
}
