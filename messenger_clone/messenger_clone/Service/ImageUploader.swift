//
//  ImageUploader.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import UIKit
import Firebase
import FirebaseStorage

enum ImageUploadType {
    case profile
    case message

    var filePath: StorageReference {
        let filename = NSUUID().uuidString

        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_images/\(filename)")
        case .message:
            return Storage.storage().reference(withPath: "/message_images/\(filename)")
        }
    }
}

struct ImageUploader {
    static func uploadImage(image: UIImage, type: ImageUploadType) async throws -> String? {
        // 圧縮
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let filename = NSUUID().uuidString
        let ref = type.filePath

        do {
            // imageData（圧縮された画像データ）を Firebase Storage にアップロード
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            // 取得したURLの絶対文字列を返します
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
}
