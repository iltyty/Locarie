//
//  PostDetailPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI

struct PostDetailPage: View {
  @Environment(\.dismiss) var dismiss

  @State private var screenSize: CGSize = .zero

  let post: PostDto
  let locationManager = LocationManager()

  var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(from: post.businessLocation)
  }

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .top) {
        images
        content
      }
      .onAppear {
        screenSize = proxy.size
      }
    }
  }
}

private extension PostDetailPage {
  var images: some View {
    Banner(urls: post.imageUrls, height: screenSize.height, indicator: false)
  }

  var content: some View {
    VStack {
      topBar
      bottomInfo
    }
  }

  var topBar: some View {
    HStack {
      backButton
      businessUser
      Spacer()
      moreButton
    }
    .padding(.horizontal)
  }

  var bottomInfo: some View {
    BottomSheet(detents: [.medium, .absoluteTop(100)]) {
      ScrollView {
        contentView.padding(.vertical)
      }
    }
  }
}

private extension PostDetailPage {
  var backButton: some View {
    Image(systemName: "chevron.backward")
      .font(.system(size: Constants.topBarButtonSize))
      .background(topBarButtonBackground)
      .padding(.trailing, Constants.topBarBackButtonTrailingPadding)
      .onTapGesture { dismiss() }
  }

  var businessUser: some View {
    HStack {
      NavigationLink {
        BusinessHomePage(post.user)
      } label: {
        AvatarView(
          imageUrl: post.businessAvatarUrl,
          size: Constants.topBarButtonBackgroundSize
        )
      }
      Text(post.businessName).fixedSize(horizontal: true, vertical: false)
    }
    .padding(.trailing)
    .background(Capsule().fill(.background))
  }

  var moreButton: some View {
    Image(systemName: "ellipsis")
      .font(.system(size: Constants.topBarButtonSize))
      .background(topBarButtonBackground)
  }

  var topBarButtonBackground: some View {
    Circle()
      .fill(.background)
      .frame(
        width: Constants.topBarButtonBackgroundSize,
        height: Constants.topBarButtonBackgroundSize
      )
  }
}

extension PostDetailPage {
  var contentView: some View {
    VStack(alignment: .leading, spacing: Constants.contentVSpacing) {
      Group {
        postStatus
        postTitle
        postContent
        Divider()
        businessAddress
        Divider()
      }
      .padding(.horizontal)
      postCard
    }
  }

  var postStatus: some View {
    HStack {
      Text(getTimeDifferenceString(from: post.time))
        .foregroundStyle(.green)
      Text(formatDistance(distance: distance))
      Spacer()
    }
  }

  var postTitle: some View {
    Text(post.title)
  }

  var postContent: some View {
    Text(post.content)
  }

  var businessAddress: some View {
    Label(post.businessAddress, systemImage: "location").lineLimit(1)
  }

  var postCard: some View {
    PostCardView(post: post, coverWidth: screenSize.width * 0.7)
  }
}

private enum Constants {
  static let topBarButtonSize: CGFloat = 30
  static let topBarButtonBackgroundSize: CGFloat = 40
  static let topBarBackButtonTrailingPadding: CGFloat = 20
  static let contentVSpacing: CGFloat = 20
}
