//
//  ChatViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/27.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import PhotosUI
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var messages = [Message]()
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    @Published var messageImage: Image?
    
    private let service: ChatService
    private var uiImage: UIImage?
            
    init(user: User) {
        self.service = ChatService(chatPartner: user)
        observeChatMessages()
    }
    
    func observeChatMessages() {
        // 非同期にメッセージを取得し、取得が完了したら{ messages inの部分の処理が実行されます
        service.observeMessages { [weak self] messages in
            guard let self = self else { return }
            // 取得したメッセージを現在のメッセージリスト（self.messages）に追加
            self.messages.append(contentsOf: messages)
        }
    }
    
    @MainActor
    func sendMessage(_ messageText: String) async throws {
        if let image = uiImage {
            try await service.sendMessage(type: .image(image))
            messageImage = nil
            uiImage = nil
        } else {
            try await service.sendMessage(type: .text(messageText))
        }
    }
    
    func updateMessageStatusIfNecessary() async throws {
        guard let lastMessage = messages.last else { return }
        try await service.updateMessageStatusIfNecessary(lastMessage)
    }
    
    func nextMessage(forIndex index: Int) -> Message? {
        return index != messages.count - 1 ? messages[index + 1] : nil
    }
    
    func removeChatListener() {
        service.removeListener()
    }
}

// MARK: - Images

extension ChatViewModel {
    
    @MainActor
    func loadImage() async throws {
        guard let uiImage = try await PhotosPickerHelper.loadImage(fromItem: selectedItem) else { return }
        self.uiImage = uiImage
        messageImage = Image(uiImage: uiImage)
    }
}
