//
//  ContentViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/26.
//

import Firebase
import Combine

class ContentViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var userSession: FirebaseAuth.User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    // エラー文 : Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
    //    private func setupSubscribers() {
    //        AuthService.shared.$userSession.sink { [weak self] userSessionFromAuthService in
    //            self?.userSession = userSessionFromAuthService
    //        }.store(in: &cancellables)
    //    }
    
    private func setupSubscribers() {
        
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.user = user
        }.store(in: &cancellables)
        
        AuthService.shared.$userSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userSessionFromAuthService in
                self?.userSession = userSessionFromAuthService
            }.store(in: &cancellables)
    }
}
