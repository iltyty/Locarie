//
//  PostDetailPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI
import UIKit

struct PostDetailPage: View {
  let post: PostDto
  let locationManager = LocationManager()

  init(_ post: PostDto) {
    self.post = post
  }

  var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(from: post.businessLocation)
  }

  @Environment(\.dismiss) var dismiss
  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .top) {
        let size = proxy.size

        underneathImageView(
          imageUrl: post.imageUrls.first,
          width: size.width,
          height: size.height
        )

        ScrollView {
          contentView(screenWidth: proxy.size.width)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20)
              .fill(.background))
            .padding(
              .top,
              proxy.size.height * Constants
                .contentTopPaddingProportion
            )
        }
        .overlay(alignment: .top) {
          scrollViewOverlay
        }
      }
//            .navigationBarBackButtonHidden()
    }
  }
}

extension PostDetailPage {
  func underneathImageView(imageUrl: String?, width: CGFloat,
                           height: CGFloat) -> some View
  {
    AsyncImageView(url: imageUrl ?? "", width: width,
                   height: height)
    { image in
      image
        .resizable()
        .scaledToFill()
        .frame(width: width, height: height)
        .ignoresSafeArea(edges: .top)
    }
  }
}

extension PostDetailPage {
  func contentView(screenWidth: CGFloat) -> some View {
    VStack(alignment: .leading, spacing: Constants.contentVSpacing) {
      HStack {
        Text(getTimeDifferenceString(from: post.time))
          .foregroundStyle(.green)
        Text(formatDistance(distance: distance))
        Spacer()
      }
      Text(post.title)
      Text(post.content)
      Divider()
      Label(post.businessLocationName, systemImage: "location")
        .lineLimit(1)
      Label(
        formatOpeningTime(from: post.businessOpenTime,
                          to: post.businessCloseTime),
        systemImage: "clock"
      )
      Divider()
      NavigationLink {
        ReviewPage()
      } label: {
        Label("Reviews", systemImage: "message")
          .tint(.primary)
      }
      PostCardView(post: post, coverWidth: screenWidth * 0.7)
    }
  }
}

extension PostDetailPage {
  var scrollViewOverlay: some View {
    HStack {
      Image(systemName: "chevron.backward")
        .font(.system(size: Constants.backButtonSize))
        .onTapGesture {
          dismiss()
        }
      NavigationLink {
        BusinessHomePage(post.user)
      } label: {
        AvatarView(
          imageUrl: post.businessAvatarUrl,
          size: Constants.avatarSize
        )
      }
      Text(post.businessName)
        .fixedSize(horizontal: true, vertical: false)
      Spacer()
      Image(systemName: "ellipsis")
        .font(.system(size: Constants.backButtonSize))
    }
    .padding(.horizontal)
  }
}

extension UINavigationController {
  override open func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.isHidden = true
  }

  public func gestureRecognizer(
    _: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
  ) -> Bool {
    true
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 36
  static let backButtonSize: CGFloat = 32
  static let contentVSpacing: CGFloat = 20
  static let contentTopPaddingProportion: CGFloat = 2 / 3
}
