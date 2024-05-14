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
      categories
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
      Text(post.publishedTime).foregroundStyle(LocarieColor.green)
      DotView()
      Text(post.user.distance(to: locationManager.location)).foregroundStyle(.secondary)
    }
  }

  var cover: some View {
    Banner(urls: post.imageUrls, isPortrait: false)
  }

  var content: some View {
    Text(post.content)
      .font(.title2)
      .lineLimit(Constants.contentLineLimit)
      .listRowSeparator(.hidden)
  }

  var categories: some View {
    ProfileCategories(post.user)
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

extension PostCardView {
  static var skeleton: some View {
    GeometryReader { _ in
      VStack(alignment: .leading) {
        HStack {
          SkeletonView(24, 24, true)
          SkeletonView(60, 10)
          SkeletonView(146, 10)
        }
        defaultCover
        SkeletonView(280, 10)
        HStack {
          SkeletonView(68, 10)
          SkeletonView(68, 10)
        }
      }
    }
  }

  static var defaultCover: some View {
    RoundedRectangle(cornerRadius: 18)
      .fill(LocarieColor.greyMedium)
      .frame(height: 267)
      .frame(maxWidth: .infinity)
  }
}

private enum Constants {
  static let vSpacing = 5.0
  static let avatarSize: CGFloat = 28
  static let coverAspectRatio: CGFloat = 4 / 3
  static let coverBorderRadius: CGFloat = 10.0
  static let contentLineLimit = 2
}
