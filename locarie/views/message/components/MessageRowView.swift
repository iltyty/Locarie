//
//  MessageRow.swift
//  locarie
//
//  Created by qiuty on 2023/11/1.
//

import SwiftUI

struct MessageRowView: View {
    var body: some View {
        HStack(alignment: .top) {
            AvatarView(name: "avatar", size: Constants.avatarSize)
            VStack(alignment: .leading) {
                Text("Tony Stark")
                Text("Hello, I'm Iron Man!")
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
    MessageRowView()
}
