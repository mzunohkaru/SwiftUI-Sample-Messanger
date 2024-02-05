//
//  Message.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/26.
//

import Firebase
import FirebaseFirestoreSwift

enum MessageSendType {
    case text(String)
    case image(UIImage)
    case link(String)
}

enum ContentType {
    case text(String)
    case image(String)
    case link(String)
}

struct Message: Identifiable, Codable, Hashable {
    
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    let text: String
    let timestamp: Timestamp
    var user: User?
    var read: Bool
    var imageUrl: String?
    
    var id: String {
        return messageId ?? NSUUID().uuidString
    }
    
    var chatPartnerId: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    
    var isImageMessage: Bool {
        return imageUrl != nil
    }
    
    var contentType: ContentType {
        if let imageUrl = imageUrl {
            return .image(imageUrl)
        }
        
        if text.hasPrefix("http") {
            return .link(text)
        }
        
        return .text(text)
    }
}

struct Conversation: Identifiable, Hashable, Codable {
    @DocumentID var conversationId: String?
    let lastMessage: Message
    var firstMessageId: String?
    
    var id: String {
        return conversationId ?? NSUUID().uuidString
    }
}
