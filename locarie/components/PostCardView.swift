//
//  PostCard.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct PostCardView: View {
    let coverWidth: CGFloat
    
    var body: some View {
        NavigationLink {
            PostDetailPage()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                cover(width: coverWidth).padding([.horizontal, .top])
                content.padding(.horizontal)
            }
            .background(RoundedRectangle(cornerRadius: Constants.coverBorderRadius).fill(.white))
            .tint(.primary)
        }
        .buttonStyle(FlatLinkStyle())
    }
}

extension PostCardView {
    func cover(width: CGFloat) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                coverBuilder(cover: Image("cover"), width: width)
                coverBuilder(cover: Image("BusinessCover"), width: width)
            }
        }
    }
    
    func coverBuilder(cover: Image, width: CGFloat) -> some View {
        cover
            .resizable()
            .scaledToFill()
            .frame(width: width, height: width / Constants.coverAspectRatio)
            .clipped()
            .listRowInsets(EdgeInsets())
            .clipShape(RoundedRectangle(cornerRadius: Constants.coverBorderRadius))
    }
}

extension PostCardView {
    var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("1 min ago").foregroundStyle(.green)
                Text("·")
                Text("3 km").foregroundStyle(.secondary)
            }
            Text("Today's new arrivals.")
                .font(.title2)
                .listRowSeparator(.hidden)
            HStack {
                AvatarView(name: "avatar", size: Constants.avatarSize)
                Text("Shreeji")
                Spacer()
                Image(systemName: "map")
            }
            .padding([.bottom], Constants.bottomPadding)
        }
    }
}

struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

fileprivate struct Constants {
    static let avatarSize: CGFloat = 32
    static let coverAspectRatio: CGFloat = 4 / 3
    static let coverBorderRadius: CGFloat = 10.0
    static let bottomPadding: CGFloat = 15.0
}

#Preview {
    PostCardView(coverWidth: 300)
        .padding()
}
