//
//  Route.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/28.
//

import Foundation

enum Route: Hashable {
    case profile(User)
    case chatView(User)
}
