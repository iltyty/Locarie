//
//  BusinessHomePage.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import SwiftUI

struct BusinessHomePage: View {
  @Environment(\.dismiss) var dismiss

  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .top) {
        let width = proxy.size.width
        let height = proxy.size.height * Constants
          .underneathImageHeightProportion

        underneathImageView(width: width, height: height)

        ScrollView {
          infoView
            .padding()
            .background(
              RoundedRectangle(cornerRadius: Constants
                .scrollViewCornerRadius)
                .fill(.background)
            )
            .padding(.top, proxy.size.height / 5)
        }
        .overlay {
          overlayView(width: proxy.size.width)
        }
      }
    }
  }
}

extension BusinessHomePage {
  func underneathImageView(width: Double, height: Double) -> some View {
    AsyncImageView(url: user.profileImageUrls.first ?? "", width: width,
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

extension BusinessHomePage {
  var infoView: some View {
    VStack(alignment: .leading, spacing: Constants.infoViewVSpace) {
      infoHeaderView
      buttonView
      Divider()
      Label(user.address, systemImage: "location")
        .lineLimit(1)
//      Label(
//        formatOpeningTime(from: user.openTime, to: user.closeTime),
//        systemImage: "clock"
//      )
        .lineLimit(1)
      Label(user.homepageUrl, systemImage: "link")
        .lineLimit(1)
        .tint(.primary)
      Label(user.phone, systemImage: "phone")
        .lineLimit(1)
      Divider()
      Label("Reviews", systemImage: "message")
    }
  }
}

extension BusinessHomePage {
  var buttonView: some View {
    HStack {
      buttonBuilder(text: "55 mins ago", systemImage: "heart")
      buttonBuilder(text: "Check-in", systemImage: "hand.thumbsup")
      buttonBuilder(text: "688", systemImage: "bookmark")
    }
  }

  func buttonBuilder(text: String, systemImage: String) -> some View {
    HStack {
      Image(systemName: systemImage)
      Text(text)
        .lineLimit(1)
    }
    .padding(.horizontal, Constants.infoViewButtonHPadding)
    .padding(.vertical, Constants.infoViewButtonVPadding)
    .background(
      Capsule().fill(.background)
        .shadow(radius: Constants.infoViewButtonShadowRadius)
    )
  }
}

extension BusinessHomePage {
  var infoHeaderView: some View {
    VStack(alignment: .leading) {
      HStack {
        AvatarView(
          imageUrl: user.avatarUrl,
          size: Constants.infoViewAvatarSize
        )
        Spacer()
        Image(systemName: "message")
          .font(.system(size: Constants.infoViewBtnMessageSize))
          .padding()
          .background(
            Circle().fill(.background)
              .shadow(radius: Constants
                .infoViewBtnMessageShadowRadius)
          )
      }

      HStack {
        Text(user.username)
        Spacer()
        ForEach(user.categories, id: \.self) { category in
          Text(category).foregroundStyle(.secondary)
        }
      }

      Text(user.introduction)
        .lineLimit(Constants.infoViewIntroductionLineLimit)
    }
  }
}

extension BusinessHomePage {
  func overlayView(width _: Double) -> some View {
    VStack {
      HStack {
        Image(systemName: "chevron.backward")
          .font(.system(size: Constants.overlayViewBtnSize))
          .onTapGesture {
            dismiss()
          }
        Spacer()
        Image(systemName: "ellipsis")
          .font(.system(size: Constants.overlayViewBtnSize))
      }
      .padding(.horizontal)

      Spacer()

      Divider()
        .shadow(
          color: .black,
          radius: Constants.overlayViewDividerShadowRadius,
          y: Constants.overlayViewDividerShadowY
        )

      Capsule()
        .fill(Constants.overlayViewBtnMapColor)
        .frame(
          width: Constants.overlayViewBtnMapWidth,
          height: Constants.overlayViewBtnMapHeight
        )
        .overlay {
          Label("Map", systemImage: "map")
            .fontWeight(.bold)
            .foregroundStyle(.white)
        }
    }
  }
}

private enum Constants {
  static let underneathImageHeightProportion = 0.5
  static let scrollViewCornerRadius: CGFloat = 20
  static let infoViewVSpace: CGFloat = 20
  static let infoViewButtonShadowRadius: CGFloat = 2
  static let infoViewButtonHPadding: CGFloat = 8
  static let infoViewButtonVPadding: CGFloat = 12
  static let infoViewAvatarSize: CGFloat = 64
  static let infoViewBtnMessageSize: CGFloat = 20
  static let infoViewBtnMessageShadowRadius: CGFloat = 5
  static let infoViewIntroductionLineLimit = 5
  static let overlayViewBtnSize: CGFloat = 32
  static let overlayViewBtnMapColor =
    Color(red: 236 / 255, green: 100 / 255, blue: 43 / 255)
  static let overlayViewBtnMapWidth: CGFloat = 120
  static let overlayViewBtnMapHeight: CGFloat = 50
  static let overlayViewDividerShadowRadius: CGFloat = 2
  static let overlayViewDividerShadowY: CGFloat = 2
}
