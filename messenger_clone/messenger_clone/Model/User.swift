//
//  User.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/22.
//

import Foundation
import FirebaseFirestoreSwift

// Codable : JSON文字列をSwiftのクラスにエンコード/デコードができるプロトコル
struct User: Identifiable, Codable, Hashable {
    
    @DocumentID var userId: String?
    let fullname: String
    let email: String
    var profileImageUrl: String?
    
    var id: String {
        return userId ?? NSUUID().uuidString
    }
    
    var firstName: String {
        let components = fullname.components(separatedBy: " ")
        return components.first ?? fullname
    }
}

extension User: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
