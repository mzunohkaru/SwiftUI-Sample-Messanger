//
//  InboxService.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/27.
//

import Foundation
import Firebase

class InboxService {
    
    @Published var documentChanges = [DocumentChange]()
    
    static let shared = InboxService()
    
    //  Firestoreの特定のコレクションやドキュメントの変更をリアルタイムで監視するためのリスナー
    private var firestoreListener: ListenerRegistration?
    
    // need to call this thru shared instance to setup the observer
    func observeRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = FirestoreConstants.MessagesCollection
            .document(uid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        // FirestoreからのSnapshotListenerを通じてドキュメントの変更情報が取得され、それがdocumentChangesに格納されます
        self.firestoreListener = query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({
                // 変更が追加または変更であるものだけをフィルタリング
                $0.type == .added || $0.type == .modified
            }) else { return }
            
            self.documentChanges = changes
        }
    }
    
    static func deleteMessage(_ message: Message) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = message.chatPartnerId
        
        let snapshot = try await FirestoreConstants.MessagesCollection.document(uid).collection(chatPartnerId).getDocuments()
        
        // withThrowingTaskGroup : 複数の非同期タスクを並行して実行が可能
        // (of: Void.self) : Void型の結果を持つタスクグループを作成
        await withThrowingTaskGroup(of: Void.self) { group in
            for doc in snapshot.documents {
                // タスクグループに新しいタスクを追加
                group.addTask {
                    // メッセージデータを削除
                    try await FirestoreConstants.MessagesCollection
                        .document(uid)
                        .collection(chatPartnerId)
                        .document(doc.documentID)
                        .delete()
                }
            }
            
            group.addTask {
                try await FirestoreConstants.MessagesCollection
                    .document(uid)
                    .collection("recent-messages")
                    .document(chatPartnerId)
                    .delete()
            }
        }
    }
    
    func reset() {
        self.firestoreListener?.remove()
        self.firestoreListener = nil
        self.documentChanges.removeAll()
    }
}
