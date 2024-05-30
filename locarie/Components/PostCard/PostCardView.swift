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
    VStack(alignment: .leading, spacing: 0) {
      status.padding(.bottom, 9)
      cover.padding(.bottom, 16)
      content.padding(.bottom, 10)
      categories
    }
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: Constants.coverBorderRadius).fill(.background)
  }
}

private extension PostCardView {
  var status: some View {
    HStack(spacing: 10) {
      userAvatar
      Text(post.businessName)
        .fontWeight(.bold)
      HStack(spacing: 5) {
        Text(post.publishedTime)
          .foregroundStyle(post.publishedOneDayAgo ? LocarieColor.greyDark : LocarieColor.green)
        DotView()
        Text(post.user.distance(to: locationManager.location)).foregroundStyle(LocarieColor.greyDark)
          .foregroundStyle(LocarieColor.greyDark)
        DotView()
        Text(post.user.neighborhood)
          .foregroundStyle(LocarieColor.greyDark)
      }
    }
    .font(.custom(GlobalConstants.fontName, size: 14))
    .lineLimit(1)
  }

  var cover: some View {
    Banner(urls: post.imageUrls, isPortrait: false)
  }

  var content: some View {
    Text(post.content)
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
  static let avatarSize: CGFloat = 24
  static let coverAspectRatio: CGFloat = 4 / 3
  static let coverBorderRadius: CGFloat = 10.0
  static let contentLineLimit = 2
}
