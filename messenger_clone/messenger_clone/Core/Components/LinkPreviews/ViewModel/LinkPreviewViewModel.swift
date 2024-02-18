//
//  LinkPreviewViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import LinkPresentation
import UniformTypeIdentifiers
import SwiftUI

@MainActor
class LinkPreviewViewModel: ObservableObject {
    
    // URLからリンクのメタデータを取得
    let metadataProvider = LPMetadataProvider()
    
    @Published var metadata: LPLinkMetadata?
    @Published var image: Image?
        
    init(urlString: String) {
        // URL文字列を使用してメタデータの取得
        Task { try await fetchLinkMetadata(urlString: urlString) }
    }
    
    private func fetchLinkMetadata(urlString: String)  async throws {
        guard let url = URL(string: urlString) else { return }

        // メタデータを取得
        let metadata = try await metadataProvider.startFetchingMetadata(for: url)
        self.metadata = metadata
        
        // 取得したメタデータから画像プロバイダーを取得
        guard let imageProvider = metadata.imageProvider else { return }
        // 画像データをロード
        guard let imageData = try await imageProvider.loadItem(forTypeIdentifier: UTType.image.identifier) as? Data else { return }
        
        // ロードした画像データからUIImageを生成
        guard let uiImage = UIImage(data: imageData) else { return }
        self.image = Image(uiImage: uiImage)
    }
}
