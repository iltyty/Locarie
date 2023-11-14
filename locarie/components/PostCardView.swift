//
//  PostCard.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    let coverWidth: CGFloat
    @ObservedObject var locationManager = LocationManager()
    
    var distance: Double {
        guard let location = locationManager.location else { return 0 }
        return location.distance(from: post.businessLocation)
    }
    
    var body: some View {
        NavigationLink {
            PostDetailPage(post)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                cover(width: coverWidth).padding([.horizontal, .top])
                content.padding(.horizontal)
            }
            .background(RoundedRectangle(cornerRadius: Constants.coverBorderRadius).fill(.white))
            .tint(.primary)
            .onAppear {
                print(locationManager.location)
            }
        }
        .buttonStyle(FlatLinkStyle())
    }
}

extension PostCardView {
    func cover(width: CGFloat) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(post.imageNames, id: \.self) { imageName in
                    coverBuilder(imageName: imageName, width: width)
                }
            }
        }
    }
    
    func coverBuilder(imageName: String, width: CGFloat) -> some View {
        Image(imageName)
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
                Text(getTimeDifferenceString(from: post.time)).foregroundStyle(.green)
                Text("·")
                Text(formatDistance(distance: distance)).foregroundStyle(.secondary)
            }
            Text(post.title)
                .font(.title2)
                .listRowSeparator(.hidden)
            HStack {
                AvatarView(image: post.businessAvatar, size: Constants.avatarSize)
                Text(post.businessName)
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
    PostCardView(post: PostViewModel().posts[0], coverWidth: 300)
        .padding()
}
