//
//  LPLinkViewRepresented.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import LinkPresentation
import SwiftUI

class CustomLinkView: LPLinkView {
    override var intrinsicContentSize: CGSize { CGSize(width: 0, height: super.intrinsicContentSize.height) }
}

struct LPLinkViewRepresented: UIViewRepresentable {
    typealias UIViewType = CustomLinkView
    var metadata: LPLinkMetadata
    
    func makeUIView(context: Context) -> CustomLinkView {
        let linkView = CustomLinkView(metadata: metadata)
        return linkView
    }
    
    func updateUIView(_ uiView: CustomLinkView, context: Context) {}
}
