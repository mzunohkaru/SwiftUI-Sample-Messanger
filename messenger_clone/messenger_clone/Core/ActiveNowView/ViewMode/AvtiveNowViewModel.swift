//
//  AvtiveNowViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/28.
//

import Foundation

class ActiveNowViewModel: ObservableObject {
    
    @Published var users = [User]()
    private let fetchLimit = 10
    
    init() {
        Task { try await fetchUsers() }
    }
    
    @MainActor
    func fetchUsers() async throws {
        self.users = try await UserService.fetchUsers(limit: fetchLimit)
    }
}
