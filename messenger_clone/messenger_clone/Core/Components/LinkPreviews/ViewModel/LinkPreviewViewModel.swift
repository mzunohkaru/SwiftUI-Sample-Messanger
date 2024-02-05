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
    let metadataProvider = LPMetadataProvider()
    
    @Published var metadata: LPLinkMetadata?
    @Published var image: Image?
        
    init(urlString: String) {
        
        Task { try await fetchLinkMetadata(urlString: urlString) }
    }
    
    private func fetchLinkMetadata(urlString: String)  async throws {
        guard let url = URL(string: urlString) else { return }

        let metadata = try await metadataProvider.startFetchingMetadata(for: url)
        self.metadata = metadata
                
        guard let imageProvider = metadata.imageProvider else { return }
        guard let imageData = try await imageProvider.loadItem(forTypeIdentifier: UTType.image.identifier) as? Data else { return }
        
        guard let uiImage = UIImage(data: imageData) else { return }
        self.image = Image(uiImage: uiImage)
    }
}
