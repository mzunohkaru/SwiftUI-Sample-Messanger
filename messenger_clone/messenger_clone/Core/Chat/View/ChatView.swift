//
//  ChatView.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/22.
//

import SwiftUI

struct ChatView: View {
    
    @State private var messageText = ""
    @State private var isInitialLoad = false
    @StateObject var viewModel: ChatViewModel
    private let user: User
    private var thread: Thread?
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        VStack {
                            CircularProfileImageView(user: user, size: .xLarge)
                            
                            VStack(spacing: 4) {
                                Text(user.fullname)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text("Messenger")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        // .indices : viewModel.messages配列の全てのインデックスを返します
                        ForEach(viewModel.messages.indices, id: \.self) { index in
                            // viewModel.messages[index] : viewModel.messages配列から特定のメッセージを取得
                            ChatMessageCell(message: viewModel.messages[index],
                                            nextMessage: viewModel.nextMessage(forIndex: index))
                            // .id() : ViewModifierで、特定のビューに一意のIDを割り当てます
                            .id(viewModel.messages[index].id)
                        }
                    }
                    .padding(.vertical)
                }
                .onChange(of: viewModel.messages) { newValue in
                    guard  let lastMessage = newValue.last else { return }
                    
                    withAnimation(.spring()) {
                        proxy.scrollTo(lastMessage.id)
                    }
                }
            }
            
            Spacer()
            
            MessageInputView(messageText: $messageText, viewModel: viewModel)
        }
        .onDisappear {
            viewModel.removeChatListener()
        }
        .onChange(of: viewModel.messages, perform: { _ in
            Task { try await viewModel.updateMessageStatusIfNecessary()}
        })
        .navigationTitle(user.fullname)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(user: dev.user)
    }
}
