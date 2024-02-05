//
//  UserService.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/26.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants.UsersCollection.document(uid).getDocument()
        self.currentUser = try snapshot.data(as: User.self)
    }
    
    static func fetchUser(uid: String) async throws -> User {
        let snapshot = try await FirestoreConstants.UsersCollection.document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchUsers(limit: Int? = nil) async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let query = FirestoreConstants.UsersCollection
        
        if let limit {
            // 取得する最大数を設定
            let snapshot = try await query.limit(to: limit).getDocuments()
            return mapUsers(fromSnapshot: snapshot, currentUid: currentUid)
        }
        
        let snapshot = try await query.getDocuments()
        return mapUsers(fromSnapshot: snapshot, currentUid: currentUid)
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        // Firestoreから取得したドキュメントのデータはsnapshotに格納されます
        // エラー情報は無視されます （_）
        FirestoreConstants.UsersCollection.document(uid).getDocument { snapshot, _ in
            // snapshotのデータをUser型への変換し、それをuserに格納
            guard let user = try? snapshot?.data(as: User.self) else {
                print("DEBUG: Failed to map user")
                return
            }
            completion(user)
        }
    }
    
    private static func mapUsers(fromSnapshot snapshot: QuerySnapshot, currentUid: String) -> [User] {
        return snapshot.documents
            .compactMap({ try? $0.data(as: User.self) })
            .filter({ $0.id !=  currentUid }) // 現在のユーザー以外を配列に格納
    }
}

// MARK: - Update User Data

extension UserService {
    @MainActor
    func updateUserProfileImageUrl(_ profileImageUrl: String) async throws {
        self.currentUser?.profileImageUrl = profileImageUrl
        try await FirestoreConstants.UsersCollection.document(currentUser?.id ?? "").updateData([
            "profileImageUrl": profileImageUrl
        ])
    }
}
