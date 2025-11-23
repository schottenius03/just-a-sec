//
//  UserRepository.swift
//  JustASec
//
//  Created by Kailing Schottenius on 21/11/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserRepository {
    // create instane of repository
    static let sharedUserRepository = UserRepository()
    // ref root-collection
    private let usersCollection: CollectionReference
    
    // instance to Firestore
    init() {
        let db = Firestore.firestore()
        self.usersCollection = db.collection("users")
    }
    
    func addOrUpdate(user: User) async throws {
        guard let userId = user.id else {
            throw JASError.userIdNotFound
        }
        
        do {
            try usersCollection.document(userId).setData(from: user, merge: true)
        } catch let encodingError as EncodingError {
            throw JASError.encodingError(encodingError)
        } catch {
            throw JASError.firestoreError(error)
        }
    }
    
    func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
