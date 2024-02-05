//
//  InboxViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/26.
//

import Foundation
import Combine
import Firebase

class InboxViewModel: ObservableObject {
    
    @Published var recentMessages = [Message]()
    @Published var conversations = [Conversation]()
    @Published var user: User?
    @Published var searchText = ""
    
    var filteredMessages: [Message] {
        if searchText.isEmpty {
            return recentMessages
        } else {
            return recentMessages.filter { message in
                guard let user = message.user else { return false }
                return user.fullname.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var didCompleteInitialLoad = false

    private var firestoreListener: ListenerRegistration?

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
        observeRecentMessages()
    }
    
    private func setupSubscribers() {
        // sink : 新しいユーザー情報が発行されるたびにクロージャを実行
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.user = user
            // cancellablesに保存され、ViewModelが破棄されるときに自動的にキャンセルされます
        }.store(in: &cancellables)
        
        // 新しいドキュメントの変更が発行されるたびにクロージャを実行
        InboxService.shared.$documentChanges.sink { [weak self] changes in
            // クロージャが[weak self]キャプチャリストを使用している場合、selfは弱参照となり、nilになる可能性があります
            guard let self = self, !changes.isEmpty else { return }
            
            if !self.didCompleteInitialLoad {
                // 変更をメッセージとしてロードします
                self.loadInitialMessages(fromChanges: changes)
            } else {
                self.updateMessages(fromChanges: changes)
            }
        }.store(in: &cancellables)
    }
    
    func observeRecentMessages() {
        InboxService.shared.observeRecentMessages()
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        // ドキュメントの変更をMessage型に変換
        self.recentMessages = changes.compactMap{ try? $0.document.data(as: Message.self) }
        
        for i in 0 ..< recentMessages.count {
            
            let message = recentMessages[i]
            
            // メッセージのパートナーのユーザー情報を取得
            UserService.fetchUser(withUid: message.chatPartnerId) { [weak self] user in
                // self が nil でないことを確認
                guard let self else { return }
                // 取得したユーザー情報をメッセージに関連付け
                self.recentMessages[i].user = user
                
                // 初期メッセージの読み込みが完了したかどうかを追跡するために使用
                // recentMessages.count - 1 : 配列の最後の要素のインデックス
                if i == self.recentMessages.count - 1 {
                    // 最後の要素に到達している場合
                    self.didCompleteInitialLoad = true
                }
            }
        }
    }
    
    private func updateMessages(fromChanges changes: [DocumentChange]) {
        for change in changes {
            if change.type == .added {
                self.createNewConversation(fromChange: change)
            } else if change.type == .modified {
                self.updateMessagesFromExisitingConversation(fromChange: change)
            }
        }
    }
    
    private func createNewConversation(fromChange change: DocumentChange) {
        guard var message = try? change.document.data(as: Message.self) else { return }
        
        UserService.fetchUser(withUid: message.chatPartnerId) { user in
            // チャットパートナーの情報をメッセージのユーザー情報に設定
            message.user = user
            // recentMessages 配列の先頭に message オブジェクトを挿入する
            self.recentMessages.insert(message, at: 0) // at: 0 : 配列の最初の位置
        }
    }
    
    private func updateMessagesFromExisitingConversation(fromChange change: DocumentChange) {
        // Messageオブジェクトに変換
        guard var message = try? change.document.data(as: Message.self) else { return }
        // recentMessages配列内で、変更されたメッセージのchatPartnerIdが一致する最初のメッセージのインデックスを検索
        guard let index = self.recentMessages.firstIndex(where: {
            $0.user?.id ?? "" == message.chatPartnerId
        }) else { return }

        // 見つかったメッセージのユーザー情報を、変更されたメッセージに設定
        guard let user = self.recentMessages[index].user else { return }
        message.user = user
        
        // recentMessages配列から、変更されたメッセージを削除
        self.recentMessages.remove(at: index)
        // 変更されたメッセージをrecentMessages配列の先頭に挿入
        self.recentMessages.insert(message, at: 0)
    }
    
    func deleteMessage(_ message: Message) async throws {
        do {
            recentMessages.removeAll(where: { $0.id == message.id })
            try await InboxService.deleteMessage(message)
        } catch {

        }
    }
}
