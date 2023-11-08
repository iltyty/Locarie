//
//  MessageContent.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    
    var isSentBySelf: Bool {
        return message.sender.id == 3
    }
    
    var body: some View {
        HStack {
            if isSentBySelf {
                Spacer()
            } else {
                AvatarView(image: message.sender.avatar, size: Constants.avatarSize)
            }
            Text(message.content)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: Constants.messageCornerRadius)
                        .fill(.blue)
                )
                .fixedSize(horizontal: false, vertical: true)
            if isSentBySelf {
                AvatarView(image: message.sender.avatar, size: Constants.avatarSize)
            } else {
                Spacer()
            }
        }
        .padding(.horizontal)
        .frame(alignment: .center)

    }
}

fileprivate struct Constants {
    static let avatarSize: CGFloat = 42
    static let messageCornerRadius: CGFloat = 20
    static let messageMinHeight: CGFloat = 64
    static let messageMaxWidthProportion = 0.7
}

#Preview {
    let messageVM = MessageViewModel()
    return MessageView(message: messageVM.messages[User.business1]![0])
        .background(.blue)
}
