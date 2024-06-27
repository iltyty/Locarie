//
//  BusinessProfileCover.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//

import SwiftUI

struct BusinessProfileCover: View {
  let user: UserDto
  var onAvatarTapped: () -> Void = {}
  @Binding var isPresenting: Bool

  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      CoverTopView(
        user: user,
        showMoreButton: false,
        sharePreviewText: user.businessName,
        onAvatarTapped: onAvatarTapped,
        isPresenting: $isPresenting
      )
      .padding(.bottom, 24)
      .padding(.horizontal, 8)
      Spacer()
      Banner(urls: user.profileImageUrls, isPortrait: false)
      Spacer()
      coverBottom
    }
    .padding(.horizontal, 16)
    .background(.ultraThinMaterial.opacity(CoverCommonConstants.backgroundOpacity))
  }
}

private extension BusinessProfileCover {
  var coverBottom: some View {
    VStack(alignment: .leading, spacing: 16) {
      if cacheVM.getUserId() == user.id {
        editButtonView.padding(.bottom, 14)
      }
      ProfileAddress(user)
      ProfileOpenUntil(user)
      SeeProfileButton().onTapGesture { onAvatarTapped() }
    }
    .padding(.bottom, 48)
  }

  var editButtonView: some View {
    HStack {
      Spacer()
      NavigationLink {
        UserProfileEditPage()
      } label: {
        editButton
      }
      .buttonStyle(.plain)
      Spacer()
    }
  }

  var editButton: some View {
    Label {
      Text("Edit profile")
    } icon: {
      Image("EditIcon")
        .resizable()
        .scaledToFit()
        .frame(
          width: Constants.editButtonIconSize,
          height: Constants.editButtonIconSize
        )
    }
    .padding(.horizontal, Constants.editButtonInnerPadding)
    .frame(height: Constants.editButtonHeight)
    .background(editButtonBackground)
    .padding(.top, Constants.editButtonTopPadding)
  }

  var editButtonBackground: some View {
    Capsule()
      .fill(.background)
      .shadow(radius: Constants.editButtonShadowRadius)
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 15
  static let editButtonTopPadding: CGFloat = 30
  static let editButtonInnerPadding: CGFloat = 10
  static let editButtonHeight: CGFloat = 40
  static let editButtonIconSize: CGFloat = 18
  static let editButtonShadowRadius: CGFloat = 2
}
