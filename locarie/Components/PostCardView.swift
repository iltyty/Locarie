//
//  PostCardView.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct PostCardView: View {
  @StateObject var locationManager = LocationManager()

  let post: PostDto
  let coverWidth: CGFloat

  var body: some View {
    NavigationLink {
      PostDetailPage(post: post)
    } label: {
      VStack(alignment: .leading, spacing: Constants.vSpacing) {
        cover
        content
      }
      .background(background)
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: Constants.coverBorderRadius)
      .fill(.background)
  }
}

private extension PostCardView {
  var cover: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(post.imageUrls, id: \.self) { imageUrl in
          coverBuilder(imageUrl: imageUrl, width: coverWidth)
        }
      }
      .padding(.horizontal)
    }
  }

  func coverBuilder(imageUrl: String, width: CGFloat) -> some View {
    let height = width / Constants.coverAspectRatio
    return AsyncImageView(url: imageUrl) { image in
      image
        .resizable()
        .scaledToFill()
        .frame(width: width, height: height)
        .clipped()
        .listRowInsets(EdgeInsets())
        .clipShape(RoundedRectangle(cornerRadius: Constants.coverBorderRadius))
    }.frame(width: width, height: height)
  }
}

private extension PostCardView {
  var content: some View {
    VStack(alignment: .leading, spacing: 10) {
      status
      title
      info
    }
    .padding(.horizontal)
    .padding(.bottom, Constants.bottomPadding)
  }

  var status: some View {
    HStack {
      Text(getTimeDifferenceString(from: post.time)).foregroundStyle(.green)
      Text("·")
      Text(formatDistance(distance: distance)).foregroundStyle(.secondary)
    }
  }

  var title: some View {
    Text(post.title).font(.title2).listRowSeparator(.hidden)
  }

  var info: some View {
    HStack {
      userAvatar
      businessName
      openUntil
      Spacer()
      mapButton
    }
  }

  var userAvatar: some View {
    AvatarView(imageUrl: post.businessAvatarUrl, size: Constants.avatarSize)
  }

  var businessName: some View {
    Text(post.businessName)
  }

  var openUntil: some View {
    Text(post.openUtil).foregroundStyle(.secondary)
  }

  var mapButton: some View {
    Image(systemName: "map")
  }

  var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(from: post.businessLocation)
  }
}

private enum Constants {
  static let vSpacing = 8.0
  static let avatarSize: CGFloat = 32
  static let coverAspectRatio: CGFloat = 4 / 3
  static let coverBorderRadius: CGFloat = 10.0
  static let bottomPadding: CGFloat = 15.0
}
