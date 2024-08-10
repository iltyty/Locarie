//
//  CoverTopView.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//

import Kingfisher
import SwiftUI

struct CoverTopView: View {
  let user: UserDto
  let showMoreButton: Bool
  let sharePreviewText: String
  var onAvatarTapped: () -> Void
  var onMoreButtonTapped: () -> Void

  @Binding var isPresenting: Bool

  init(
    user: UserDto,
    showMoreButton: Bool = true,
    sharePreviewText: String,
    onAvatarTapped: @escaping () -> Void = {},
    onMoreButtonTapped: @escaping () -> Void = {},
    isPresenting: Binding<Bool>
  ) {
    self.user = user
    self.showMoreButton = showMoreButton
    self.sharePreviewText = sharePreviewText
    self.onAvatarTapped = onAvatarTapped
    self.onMoreButtonTapped = onMoreButtonTapped
    _isPresenting = isPresenting
  }

  private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    HStack(spacing: 0) {
      dismissButton.padding(.trailing, 24)
      Group {
        avatar.padding(.trailing, 10)
        Text(user.businessName).fontWeight(.bold)
      }
      .onTapGesture { onAvatarTapped() }
      Spacer()
      shareButton
      if cacheVM.getUserId() == user.id, showMoreButton {
        moreButton.padding(.leading, 24)
      }
    }
  }

  var dismissButton: some View {
    buttonBuilder(Image(systemName: "multiply"))
      .onTapGesture {
        isPresenting = false
      }
  }

  @ViewBuilder
  var avatar: some View {
    Group {
      if user.avatarUrl.isEmpty {
        defaultAvatar(size: Constants.avatarSize)
      } else {
        KFImage(URL(string: user.avatarUrl))
          .placeholder { SkeletonView(Constants.avatarSize, Constants.avatarSize, true) }
          .resizable()
          .frame(size: Constants.avatarSize)
          .clipShape(Circle())
      }
    }
  }

  @ViewBuilder
  var shareButton: some View {
    ShareLink(item: URL(string: "https://apps.apple.com/us/app/locarie/id6499185074")!, message: Text("Locarie")) {
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
      .frame(size: Constants.buttonSize)
      .contentShape(Rectangle())
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 40
  static let buttonSize: CGFloat = 18
}
