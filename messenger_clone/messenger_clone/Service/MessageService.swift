//
//  MessageService.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/27.
//

import Firebase

struct MessageService {
    static func updateMessageStatusIfNecessary(_ messages: [Message]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let lastMessage = messages.last, !lastMessage.read else { return }
        
        try await FirestoreConstants.MessagesCollection
            .document(uid)
            .collection("recent-messages")
            .document(lastMessage.id)
            .updateData(["read": true])
    }
}
