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

  init(_ post: PostDto) {
    self.post = post
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      status
      cover
      content
      tags
    }
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: Constants.coverBorderRadius)
      .fill(.background)
  }
}

private extension PostCardView {
  var status: some View {
    HStack {
      userAvatar
      Text(post.businessName)
      Text(getTimeDifferenceString(from: post.time)).foregroundStyle(.green)
      Text("·")
      Text(formatDistance(distance: distance)).foregroundStyle(.secondary)
    }
  }

  var cover: some View {
    Banner(urls: post.imageUrls, isPortrait: false)
  }

  var content: some View {
    Text(post.content)
      .font(.title2)
      .listRowSeparator(.hidden)
  }

  var tags: some View {
    HStack {
      TagView(tag: "Food & Drink", isSelected: false)
      TagView(tag: "Shop", isSelected: false)
    }
  }
}

private extension PostCardView {
  var userAvatar: some View {
    AvatarView(imageUrl: post.businessAvatarUrl, size: Constants.avatarSize)
  }

  var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(from: post.businessLocation)
  }
}

private enum Constants {
  static let vSpacing = 5.0
  static let avatarSize: CGFloat = 28
  static let coverAspectRatio: CGFloat = 4 / 3
  static let coverBorderRadius: CGFloat = 10.0
}
