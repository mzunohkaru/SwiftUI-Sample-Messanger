//
//  Route.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/28.
//

import Foundation

// Hashable メリット
// 高速にデータの検索やアクセスが可能になります
// 同じパラメータを持つルートが重複して扱われることを防ぎ、データの整合性を保つことができます

enum Route: Hashable {
    case profile(User)
    case chatView(User)
}
