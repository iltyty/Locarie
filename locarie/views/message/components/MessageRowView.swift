//
//  MessageRow.swift
//  locarie
//
//  Created by qiuty on 2023/11/1.
//

import SwiftUI

struct MessageRowView: View {
    let message: Message
    
    init(_ message: Message) {
        self.message = message
    }
    
    var isSentBySelf: Bool {
        message.sender.id == 3
    }
    
    var user: User {
        isSentBySelf ? message.receiver : message.sender
    }
    
    var body: some View {
        HStack(alignment: .top) {
            AvatarView(image: user.avatar, size: Constants.avatarSize)
            VStack(alignment: .leading) {
                Text(user.username)
                Text(message.content).lineLimit(1)
            }
            Spacer()
            VStack {
                Text("Status")
                    .foregroundStyle(.secondary)
                Image(systemName: "9.circle.fill")
            }
        }
    }
}

fileprivate struct Constants {
    static let avatarSize: CGFloat = 50
}

#Preview {
    let messageVM = MessageViewModel()
    let lastMessage = messageVM.messages[User.business1]![0]
    return MessageRowView(lastMessage)
}
