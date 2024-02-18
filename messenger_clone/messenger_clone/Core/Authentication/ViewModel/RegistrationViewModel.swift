//
//  RegistrationViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/26.
//

import SwiftUI
import FirebaseAuth

class RegistrationViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var showAlert = false
    @Published var authError: AuthError?
    
    @MainActor
    func createUser() async throws {
        do {
            try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
        }
    }
}
