//
//  BusinessProfileCover.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//

import SwiftUI

struct BusinessProfileCover: View {
  let user: UserDto
  @Binding var isPresenting: Bool

  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(alignment: .leading) {
      coverTop
      blank
      profileImages
      coverBottom
      blank
    }
    .padding(.horizontal)
    .background(.thickMaterial.opacity(CoverCommonConstants.backgroundOpacity))
    .contentShape(Rectangle())
  }
}

private extension BusinessProfileCover {
  var coverTop: some View {
    CoverTopView(
      user: user,
      sharePreviewText: user.businessName,
      isPresenting: $isPresenting
    )
  }

  var blank: some View {
    Color
      .clear
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation(.spring) {
          isPresenting = false
        }
      }
  }

  var profileImages: some View {
    Banner(urls: user.profileImageUrls, isPortrait: false).padding(.bottom)
  }

  var coverBottom: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      ProfileCategories(user)
      ProfileAddress(user)
      ProfileOpenUntil(user)
      if cacheVM.getUserId() == user.id {
        editButtonView
      }
    }
  }

  var editButtonView: some View {
    HStack {
      Spacer()
      editButton
      Spacer()
    }
  }

  var editButton: some View {
    Label {
      Text("Edit images")
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
