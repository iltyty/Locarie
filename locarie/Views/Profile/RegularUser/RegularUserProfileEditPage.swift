//
//  RegularUserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 02/01/2024.
//

import PhotosUI
import SwiftUI

struct RegularUserProfileEditPage: View {
  @EnvironmentObject private var cacheViewModel: LocalCacheViewModel

  @StateObject private var photoViewModel = PhotoViewModel()
  @StateObject private var profileViewModel = ProfileViewModel()

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      navigationTitle
      avatarEditor
      avatarEditButton
      firstNameInput
      lastNameInput
      usernameInput
      emailInput
      Spacer()
    }
  }

  private var navigationTitle: some View {
    navigationTitleBuilder(title: "Edit profile")
  }

  private var avatarEditor: some View {
    PhotosPicker(
      selection: $photoViewModel.selection,
      maxSelectionCount: 1,
      matching: .images,
      photoLibrary: .shared()
    ) { getAvatar() }
  }

  private var avatarEditButton: some View {
    Button("Edit profile image") {
      print("avatar button tapped")
    }
  }

  private var firstNameInput: some View {
    formItemWithTitleBuilder(
      title: "First name",
      hint: "First name",
      input: $profileViewModel.dto.firstName,
      isSecure: false
    )
  }

  private var lastNameInput: some View {
    formItemWithTitleBuilder(
      title: "Last name",
      hint: "Last name",
      input: $profileViewModel.dto.lastName,
      isSecure: false
    )
  }

  private var usernameInput: some View {
    formItemWithTitleBuilder(
      title: "@Username",
      hint: "Username",
      input: $profileViewModel.dto.username,
      isSecure: false
    )
  }

  private var emailInput: some View {
    formItemWithTitleBuilder(
      title: "Email",
      hint: "Email",
      input: $profileViewModel.dto.email,
      isSecure: false
    )
  }
}

private extension RegularUserProfileEditPage {
  @ViewBuilder
  func getAvatar() -> some View {
    let avatarUrl = cacheViewModel.getAvatarUrl()
    if !avatarUrl.isEmpty {
      avatar(avatarUrl)
    } else if !photoViewModel.attachments.isEmpty {
      selectedImage()
    } else {
      defaultAvatar(size: Constants.avatarSize)
    }
  }

  func avatar(_ url: String) -> some View {
    AvatarView(imageUrl: url, size: Constants.avatarSize)
  }

  func selectedImage() -> some View {
    ImageAttachmentView(
      size: Constants.avatarSize,
      isCircle: true,
      attachment: photoViewModel.attachments[0]
    )
  }
}

private enum Constants {
  static let vSpacing = 24.0
  static let avatarSize = 64.0
}

#Preview {
  RegularUserProfileEditPage()
    .environmentObject(LocalCacheViewModel())
}
