//
//  MessagePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct MessagePage: View {
    @State var searchText = "Search"
    @EnvironmentObject var messageViewModel: MessageViewModel

    var messages: [User: [Message]] {
        messageViewModel.messages
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                SearchBarView(text: searchText)
                    .navigationTitle(Constants.navigationTitle)
                    .navigationBarTitleDisplayMode(.inline)

                List {
                    ForEach(messages.keys.sorted { $0.id < $1.id }) { user in
                        NavigationLink {
                            MessageDetailPage(user: user, messages: messages[user]!)
                        } label: {
                            MessageRowView(messages[user]!.last!)
                        }
                    }
                }
                .listStyle(.plain)

                BottomTabView()
            }
        }
    }

    enum Constants {
        static let navigationTitle = "Message"
    }
}

#Preview {
    MessagePage()
        .environmentObject(BottomTabViewRouter())
        .environmentObject(MessageViewModel())
}
