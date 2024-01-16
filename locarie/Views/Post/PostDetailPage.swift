//
//  PostDetailPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI
import UIKit

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
      .onAppear {
        screenSize = proxy.size
      }
    }
  }
}

private extension PostDetailPage {
  var images: some View {
    Banner(urls: post.imageUrls, height: screenSize.height)
      .ignoresSafeArea(edges: .top)
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
      Label(post.businessAddress, systemImage: "location")
        .lineLimit(1)
//      Label(
//        formatOpeningTime(from: post.businessOpenTime,
//                          to: post.businessCloseTime),
//        systemImage: "clock"
//      )
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
