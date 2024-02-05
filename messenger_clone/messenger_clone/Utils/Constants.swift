//
//  Constants.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/27.
//

import Foundation
import Firebase

struct FirestoreConstants {
    
    static let Root = Firestore.firestore()
    
    static let UsersCollection = Root.collection("users")
    
    static let MessagesCollection = Root.collection("messages")
}
