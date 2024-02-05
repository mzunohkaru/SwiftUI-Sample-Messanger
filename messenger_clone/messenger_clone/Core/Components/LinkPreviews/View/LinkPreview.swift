//
//  LinkPreview.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import SwiftUI

struct LinkPreview: View {
    @StateObject var viewModel: LinkPreviewViewModel
    
    init(urlString: String) {
        self._viewModel = StateObject(wrappedValue: LinkPreviewViewModel(urlString: urlString))
    }
    
    var body: some View {
        if let metadata = viewModel.metadata {
            LPLinkViewRepresented(metadata: metadata)
                .frame(width: UIScreen.main.bounds.width - 100, height: 250)
        } else {
            ProgressView()
                .frame(width: UIScreen.main.bounds.width - 100, height: 250)
        }
    }
}

struct LinkPreview_Previews: PreviewProvider {
    static var previews: some View {
        LinkPreview(urlString: "https://www.youtube.com/watch?v=Qg0PepGlxFs")
    }
}
