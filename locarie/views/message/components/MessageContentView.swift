//
//  MessageContent.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI

struct MessageContentView: View {
    var isSentBySelf = true
    var content: String
    var avatar: Image
    
    var body: some View {
        HStack {
            if isSentBySelf {
                Spacer()
            } else {
                AvatarView(image: avatar, size: Constants.avatarSize)
            }
            Text(content)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: Constants.messageCornerRadius)
                        .fill(.blue)
                )
                .fixedSize(horizontal: false, vertical: true)
            if isSentBySelf {
                AvatarView(image: avatar, size: Constants.avatarSize)
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
    MessageContentView(
        content: "Hello, I'm Tony Stark from the Avengers!",
        avatar: Image("avatar")
    )
    .background(.blue)
}
