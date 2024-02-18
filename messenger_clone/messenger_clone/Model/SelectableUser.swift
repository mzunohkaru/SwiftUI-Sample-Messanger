//
//  SelectableUser.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/15.
//

import Foundation

struct SelectableUser: Identifiable {
    var user: User
    var isSelected: Bool
    
    var id: String { return user.id ?? NSUUID().uuidString }
}
