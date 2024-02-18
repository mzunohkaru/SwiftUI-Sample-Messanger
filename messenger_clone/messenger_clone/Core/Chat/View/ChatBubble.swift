//
//  ChatBubble.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/22.
//

import SwiftUI

// Shapeプロトコルは図形を描画するためのメソッドを提供
struct ChatBubble: Shape {
    
    var isFromCurrentUser: Bool
    var shouldRoundAllCorners: Bool
    
    var corners: UIRectCorner {
        if shouldRoundAllCorners {
            return [.allCorners]
        } else {
            return [
                .topLeft,
                .topRight,
                isFromCurrentUser ? .bottomLeft : .bottomRight
            ]
        }
    }
    
    // 図形の描画パスを定義
    func path(in rect: CGRect) -> Path {
        // 角が丸い四角形のパスを作成
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: 16, height: 16)
        )
        // 作成したUIBezierPathをPathに変換して返す
        return Path(path.cgPath)
    }
}

#Preview {
    ChatBubble(isFromCurrentUser: true, shouldRoundAllCorners: true)
}
