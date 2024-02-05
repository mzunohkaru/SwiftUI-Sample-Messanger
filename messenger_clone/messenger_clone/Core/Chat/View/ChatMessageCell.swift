//
//  ChatMessageCell.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/22.
//

import SwiftUI

struct ChatMessageCell: View {
    
    let message: Message
    var nextMessage: Message?
    
    init(message: Message, nextMessage: Message?) {
        self.message = message
        self.nextMessage = nextMessage
    }
    
    private var shouldShowChatPartnerImage: Bool {
        if nextMessage == nil && !message.isFromCurrentUser { return true }
        guard let next = nextMessage else { return message.isFromCurrentUser }
        return next.isFromCurrentUser
    }
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                
                switch message.contentType {
                case .image(let imageUrl):
                    MessageImageView(imageUrlString: imageUrl)
                case .text(let messageText):
                    Text(messageText)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(ChatBubble(isFromCurrentUser: true, shouldRoundAllCorners: false))
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
                        .padding(.horizontal)
                case .link(let urlString):
                    LinkPreview(urlString: urlString)
                        .padding(.horizontal)
                }
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    if shouldShowChatPartnerImage {
                        CircularProfileImageView(user: message.user, size: .xxSmall)
                    }
                    
                    switch message.contentType {
                    case .image(let imageUrl):
                        MessageImageView(imageUrlString: imageUrl)
                            .padding(.leading, shouldShowChatPartnerImage ? 0 : 32)
                    case .text(let messageText):
                        Text(messageText)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .foregroundColor(Color.theme.primaryText)
                            .clipShape(ChatBubble(isFromCurrentUser: false, shouldRoundAllCorners: !shouldShowChatPartnerImage))
                            .frame(maxWidth: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                            .padding(.leading, shouldShowChatPartnerImage ? 0 : 32)
                        
                    case .link(let urlString):
                        LinkPreview(urlString: urlString)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct MessageImageView: View {
    let imageUrlString: String
    
    var body: some View {
        // URLデータに変換後、AsyncImageにURLを渡して画像をロード
        AsyncImage(url: URL(string: imageUrlString)!) { image in
            // 取得した画像ビュー
            image
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(maxWidth: UIScreen.main.bounds.width / 1.5, maxHeight: 400)
                .cornerRadius(10)
                .padding(.trailing)
        } placeholder: {
            // プレースホルダーのビュー
            ProgressView()
        }
    }
}

struct ChatMessageCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageCell(message: dev.messages[0], nextMessage: dev.messages[1])
    }
}
