//
//  NewMessageViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/26.
//

import Foundation
import Firebase

@MainActor
class NewMessageViewModel: ObservableObject {
    
    @Published var users = [User]()
    @Published var searchText = ""
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter({
                $0.fullname.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    init() {
        Task { try await fetchUsers() }
    }
    
    @MainActor
    func fetchUsers() async throws {
        self.users = try await UserService.fetchUsers()
    }
    
}

