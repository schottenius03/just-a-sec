//
//  SnoozeRepository.swift
//  JustASec
//
//  Created by Kailing Schottenius on 30/11/2025.
//

import Foundation
import FirebaseFirestore

class SnoozeRepository {

    static let sharedSnoozeRepository = SnoozeRepository()
    private let usersCollection: CollectionReference
    
    // Firestore
    init() {
        let db = Firestore.firestore()
        self.usersCollection = db.collection("users") // root
    }
    
    // Add or update snooze
    func addOrUpdate(snooze: Snooze, for userId: String) async throws {
        let collection = usersCollection.document(userId).collection("snoozes")
        
        // data to store in Firestore
        let data: [String: Any] = [
            "name": snooze.name,
            "time": snooze.time
        ]
        
        // check selected snooze
        if let snoozeId = snooze.id {
            // update
            do {
                try await collection.document(snoozeId).setData(data, merge: true)
            } catch {
                throw JASError.snoozeFirestoreError(error)
            }
        } else {
            // new
            do {
                _ = try await collection.addDocument(data: data)
            } catch {
                throw JASError.snoozeFirestoreError(error)
            }
        }
    }
    
    // MARK: Delete snooze
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
    
    func getAllSnoozesByUser(userId: String, completion: @escaping ([Snooze]) -> ()) {
        let snoozesRef = usersCollection
            .document(userId)
            .collection("snoozes")
        
        snoozesRef.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print("Firebase listener error for snoozes: \(error!.localizedDescription)")
                completion([])
                return
            }
            
            guard let snapshot = snapshot else {
                completion([])
                return
            }
            
            var decodedSnoozes: [Snooze] = []
            
            for document in snapshot.documents {
                do {
                    let snooze = try document.data(as: Snooze.self)
                    decodedSnoozes.append(snooze)
                } catch {
                    print("Error decoding document \(document.documentID) into Snooze: \(error.localizedDescription)")
                }
            }
            completion(decodedSnoozes)
        }
    }
}
