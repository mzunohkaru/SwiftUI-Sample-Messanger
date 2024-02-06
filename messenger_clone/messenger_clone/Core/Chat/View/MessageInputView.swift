//
//  MessageInputView.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import SwiftUI
import PhotosUI

struct MessageInputView: View {
    
    @Binding var messageText: String
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                if let image = viewModel.messageImage {
                    ZStack(alignment: .topTrailing) {
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 80, height: 140)
                            .cornerRadius(10)
                        
                        Button(action: {
                            viewModel.messageImage = nil
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                                .padding(8)
                        })
                        .background(Color(.gray))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    }
                    .padding(8)
                    
                    Spacer()
                } else {
                    if messageText.isEmpty {
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            Image(systemName: "photo")
                                .padding(.horizontal, 4)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    TextField("Message..", text: $messageText, axis: .vertical)
                        .padding(12)
                        .padding(.leading, 4)
                        .padding(.trailing, 48)
                        .background(Color.theme.secondaryBackground)
                        .clipShape(Capsule())
                        .font(.subheadline)
                }
            }
            
            Button {
                if messageText.isEmpty &&
                    viewModel.messageImage == nil { return }
                
                Task {
                    try await viewModel.sendMessage(messageText)
                    messageText = ""
                }
            } label: {
                Text("Send")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
        }
        .overlay {
            if viewModel.messageImage != nil {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView(messageText: .constant(""),
                         viewModel: ChatViewModel(user: dev.user))
    }
}
