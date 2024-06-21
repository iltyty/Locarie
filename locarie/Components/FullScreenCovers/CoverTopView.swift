//
//  CoverTopView.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//

import SwiftUI

struct CoverTopView: View {
  let user: UserDto
  let sharePreviewText: String
  var onAvatarTapped: () -> Void = {}
  var onMoreButtonTapped: () -> Void = {}

  @Binding var isPresenting: Bool

  var body: some View {
    HStack(spacing: 0) {
      dismissButton.padding(.trailing, 24)
      avatar.padding(.trailing, 10)
      Text(user.businessName).fontWeight(.bold)
      Spacer()
      shareButton.padding(.trailing, 24)
      moreButton
    }
  }

  var dismissButton: some View {
    buttonBuilder(Image(systemName: "multiply"))
      .onTapGesture {
        isPresenting = false
      }
  }

  var avatar: some View {
    AsyncImage(url: URL(string: user.avatarUrl)) { image in
      image
        .resizable()
        .scaledToFill()
        .frame(width: Constants.avatarSize, height: Constants.avatarSize)
        .clipShape(Circle())
    } placeholder: {
      SkeletonView(Constants.avatarSize, Constants.avatarSize, true)
    }
    .onTapGesture {
      onAvatarTapped()
    }
  }

  @ViewBuilder
  var shareButton: some View {
    let link = URL(string: "https://www.hackingwithswift.com")!
    ShareLink(
      item: link,
      preview: SharePreview(sharePreviewText, image: Image("LocarieIcon"))
    ) {
      buttonBuilder(Image("ShareIcon"))
    }
  }

  var moreButton: some View {
    buttonBuilder(Image(systemName: "ellipsis")).onTapGesture {
      onMoreButtonTapped()
    }
  }

  func buttonBuilder(_ image: Image) -> some View {
    image
      .resizable()
      .scaledToFit()
      .frame(width: Constants.buttonSize, height: Constants.buttonSize)
      .contentShape(Rectangle())
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 40
  static let buttonSize: CGFloat = 18
}
