//
//  InboxRowView.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/22.
//

import SwiftUI

struct InboxRowView: View {
    
    let message: Message
    @ObservedObject var viewModel: InboxViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            HStack {
                if !message.read && !message.isFromCurrentUser {
                    Circle()
                        .fill(Color(.systemBlue))
                        .frame(width: 6, height: 6, alignment: .leading)
                }
                
                CircularProfileImageView(user: message.user, size: .medium)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let user = message.user {
                    Text(user.fullname)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.primaryText)
                }
                
                Text("\(message.isFromCurrentUser ? "You: \(message.text)" : message.text)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack {
                Text(message.timestamp.dateValue().timestampString())
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundColor(.gray)
            
        }
        .frame(maxHeight: 72)
        .swipeActions(content: {
            withAnimation(.spring()) {
                Button {
                    Task { try await viewModel.deleteMessage(message) }
                } label: {
                    Image(systemName: "trash")
                }
                .tint(Color(.systemRed))
            }
        })
    }
}

struct InboxRowView_Previews: PreviewProvider {
    static var previews: some View {
        InboxRowView(message: dev.messages[0], viewModel: InboxViewModel())
    }
}
