//
//  ProfileRowView.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import SwiftUI

struct ProfileRowView: View {
    let viewModel: SettingsOptionsViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: viewModel.imageName)
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundStyle(Color.theme.background, viewModel.imageBackgroundColor)
            
            Text(viewModel.title)
                .font(.subheadline)
        }
    }
}

//#Preview {
//    ProfileRowView()
//}
