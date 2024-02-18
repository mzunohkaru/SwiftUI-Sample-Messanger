//
//  PhotosPickerHelper.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotosPickerHelper {
    static func loadImage(fromItem item: PhotosPickerItem?) async throws -> UIImage? {
        // 画像が選択されているか確認
        guard let item = item else { return nil }
        // 画像データを取得
        guard let data = try await item.loadTransferable(type: Data.self) else { return nil }
        // UIImageの作成
        guard let uiImage = UIImage(data: data) else { return nil }
        return uiImage
    }
}
