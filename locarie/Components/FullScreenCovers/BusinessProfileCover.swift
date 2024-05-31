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
      CoverTopView(
        user: user,
        sharePreviewText: user.businessName,
        isPresenting: $isPresenting
      )
      .padding(.bottom, 24)
      .padding(.horizontal, 8)
      Spacer()
      Banner(urls: user.profileImageUrls, indicator: .bottom, isPortrait: false).padding(.bottom)
      Spacer()
      coverBottom
    }
    .padding(.horizontal, 16)
    .background(.ultraThinMaterial.opacity(0.95))
  }
}

private extension BusinessProfileCover {
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

  var coverBottom: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      if cacheVM.getUserId() == user.id {
        editButtonView.padding(.bottom, 14)
      }
      ProfileAddress(user)
      ProfileOpenUntil(user)
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
