//
//  ChatService.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/27.
//

import Foundation
import Firebase

class ChatService {
    
    let chatPartner: User
    private let fetchLimit = 50
    
    private var firestoreListener: ListenerRegistration?
    
    init(chatPartner: User) {
        self.chatPartner = chatPartner
    }
    
    // 非同期待機が導入される前にAPI呼び出しで行う必要があるもの
    func observeMessages(completion: @escaping([Message]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        let query = FirestoreConstants.MessagesCollection
            .document(currentUid)
            .collection(chatPartnerId)
            .limit(toLast: fetchLimit)
            .order(by: "timestamp", descending: false)
        
        // データベースの該当コレクションに変更があった場合に、その変更を検知して処理を行うことができます
        self.firestoreListener = query.addSnapshotListener { [weak self] snapshot, _ in
            // snapshotからドキュメントの変更を取得し、その中から新たに追加されたもの（.added）だけをフィルタリングします
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            
            // フィルタリングしたデータから、1つずつメッセージのデータを取り出し、それをMessage型のオブジェクトに変換
            var messages = changes.compactMap{ try? $0.document.data(as: Message.self) }
            
            // 取得したメッセージのリストをループし、現在のユーザーからのメッセージでないもの（つまり、チャットパートナーからのメッセージ）を特定
            // enumerated() : 配列messagesの各要素messageとそのインデックスindexを出力します.
            //                ループ内で要素の位置を知る必要がある場合に便利
            for (index, message) in messages.enumerated() where message.fromId != currentUid {
                // 特定したメッセージのユーザー情報を、チャットパートナーの情報で更新
                messages[index].user = self?.chatPartner
            }
            
            completion(messages)
            // completion: @escaping([Message]) -> Voidの利点は、非同期処理の結果を関数の外部で利用できるようにすること
            /// この関数はFirestoreのデータベースからデータを非同期に取得するため、
            /// データの取得が完了した時点で何らかの処理を行いたい場合には、その処理をcompletionハンドラーに記述します。
            /// そして、データの取得が完了したらcompletionハンドラーが呼び出され、その中の処理が実行されます
        }
    }
    
    func sendMessage(type: MessageSendType) async throws {

        switch type {
        case .text(let messageText), .link(let messageText):
            uploadMessage(messageText)
            
        case .image(let uIImage):
            let imageUrl = try await ImageUploader.uploadImage(image: uIImage, type: .message)
            uploadMessage("Attachment: Image", imageUrl: imageUrl)
        }
    }
    
    private func uploadMessage(_ messageText: String, imageUrl: String? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        let currentUserRef = FirestoreConstants.MessagesCollection.document(currentUid).collection(chatPartnerId).document()
        let chatPartnerRef = FirestoreConstants.MessagesCollection.document(chatPartnerId).collection(currentUid)
        
        let recentCurrentUserRef = FirestoreConstants.MessagesCollection
            .document(currentUid)
            .collection("recent-messages")
            .document(chatPartnerId)
        
        let recentPartnerRef = FirestoreConstants.MessagesCollection
            .document(chatPartnerId)
            .collection("recent-messages")
            .document(currentUid)
        
        let messageId = currentUserRef.documentID
        let message = Message(
            messageId: messageId,
            fromId: currentUid,
            toId: chatPartnerId,
            text: messageText,
            timestamp: Timestamp(),
            read: false,
            imageUrl: imageUrl
        )
        var currentUserMessage = message
        currentUserMessage.read = true
        
        guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
        guard let encodedMessageCopy = try? Firestore.Encoder().encode(currentUserMessage) else { return }
        
        currentUserRef.setData(encodedMessageCopy)
        chatPartnerRef.document(messageId).setData(encodedMessage)
        
        recentCurrentUserRef.setData(encodedMessageCopy)
        recentPartnerRef.setData(encodedMessage)
    }
    
    func updateMessageStatusIfNecessary(_ message: Message) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !message.read else { return }
        
        try await FirestoreConstants.MessagesCollection
            .document(uid)
            .collection("recent-messages")
            .document(message.chatPartnerId)
            .updateData(["read": true])
    }
    
    func removeListener() {
        self.firestoreListener?.remove()
        self.firestoreListener = nil
    }
}
