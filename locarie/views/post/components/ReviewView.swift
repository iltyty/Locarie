//
//  ReviewView.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI

struct ReviewView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.elementVSpacing) {
            user
            status
            content
            bottom
        }
    }
}

extension ReviewView {
    var user: some View {
        HStack {
            AvatarView(imageUrl: "https://picsum.photos/200", size: Constants.avatarSize)
            Text("Tony Stark")
        }
    }
}

extension ReviewView {
    var status: some View {
        HStack {
            Text("Online").foregroundStyle(.green)
            Text("1 day ago").foregroundStyle(.secondary)
        }
    }
}

extension ReviewView {
    var content: some View {
        Text("Comment on what’s the shop is like. Share it with the community so people could get to know what is the vibe of this local shop.")
            .foregroundStyle(.primary)
    }
}

extension ReviewView {
    var bottom: some View {
        HStack {
            Label("helpful", systemImage: "hand.thumbsup")
            Spacer()
            Image(systemName: "ellipsis")
        }
    }
}

fileprivate struct Constants {
    static let avatarSize: CGFloat = 48
    static let elementVSpacing: CGFloat = 15
}

#Preview {
    ReviewView()
}
