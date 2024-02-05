//
//  InboxView.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/22.
//

import SwiftUI

struct InboxView: View {
    
    @State private var showNewMessageView = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showChat = false
    @State private var showProfile = false
    
    var body: some View {
        NavigationStack {
            List {
                ActiveNowView()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom)
                    .padding(.horizontal, 8)
                
                ForEach(viewModel.filteredMessages) { recentMessage in
                    ZStack {
                        NavigationLink(value: recentMessage) {
                            EmptyView()
                        }.opacity(0.0)
                        
                        InboxRowView(message: recentMessage, viewModel: viewModel)
                            .onAppear {
                                if recentMessage == viewModel.recentMessages.last {
                                    print("DEBUG: Paginate here..")
                                }
                            }
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical)
                .padding(.trailing, 8)
                .padding(.leading, 20)
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search")
            .listStyle(PlainListStyle())
            // selectedUserが変更されたら、呼ばれる
            .onChange(of: selectedUser, perform: { newValue in
                // selectedUserが nil でない場合に、showChat をtrueにする
                showChat = newValue != nil
            })
            .fullScreenCover(isPresented: $showNewMessageView, content: {
                NewMessageView(selectedUser: $selectedUser)
            })
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    ChatView(user: user)
                }
            })
            .navigationDestination(isPresented: $showChat, destination: {
                if let user = selectedUser {
                    ChatView(user: user)
                }
            })
            .navigationDestination(isPresented: $showProfile, destination: {
                if let user = viewModel.user {
                    ProfileView(user: user)
                }
            })
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                case .profile(let user):
                    ProfileView(user: user)
                case .chatView(let user):
                    ChatView(user: user)
                }
            })
            .overlay { if !viewModel.didCompleteInitialLoad { ProgressView() } }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let user = viewModel.user {
                        CircularProfileImageView(user: user, size: .xSmall)
                            .onTapGesture { showProfile.toggle() }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "square.and.pencil.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(Color.theme.primaryText, Color(.systemGray5))
                        .onTapGesture {
                            showNewMessageView.toggle()
                            selectedUser = nil
                        }
                }
            }
        }
    }
}

#Preview {
    InboxView()
}
