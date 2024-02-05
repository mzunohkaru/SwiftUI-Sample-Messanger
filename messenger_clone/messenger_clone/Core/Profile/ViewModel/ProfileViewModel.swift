//
//  ProfileViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/22.
//

import SwiftUI
import PhotosUI

class ProfileViewModel: ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        // 写真が選択されるたびに呼ばれる
        didSet {
            Task {
                try await loadImage()
            }
        }
    }
    
    @Published var profileImage: Image?
    
    func loadImage() async throws {
        guard let uiImage = try await PhotosPickerHelper.loadImage(fromItem: selectedItem) else { return }
        profileImage = Image(uiImage: uiImage)
        try await updateUserProfileImage(uiImage)
    }
    
    func updateUserProfileImage(_ uiImage: UIImage) async throws {
            guard let imageUrl = try? await ImageUploader.uploadImage(image: uiImage, type: .profile) else { return }
            try await UserService.shared.updateUserProfileImageUrl(imageUrl)
        }
}
