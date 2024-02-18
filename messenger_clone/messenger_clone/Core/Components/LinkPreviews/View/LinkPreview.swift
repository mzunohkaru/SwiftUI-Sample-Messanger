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

        // viewModelからメタデータが取得できた場合
        if let metadata = viewModel.metadata {
            // メタデータを受け取り、それを基にリンクのプレビューを表示するカスタムビュー
            LPLinkViewRepresented(metadata: metadata)
                .frame(width: UIScreen.main.bounds.width - 100, height: 250)
        } else {
            // 開発中にXcodeのプレビューキャンバスでこのビューをプレビューするためのコード
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
