//
//  RegularUserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 02/01/2024.
//

import PhotosUI
import SwiftUI

struct RegularUserProfileEditPage: View {
  @StateObject private var avatarViewModel = AvatarUploadViewModel()
  @StateObject private var profileViewModel = ProfileUpdateViewModel()
  @StateObject private var cacheViewModel = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      navigationTitle
      avatarEditor
      firstNameInput
      lastNameInput
      usernameInput
      emailInput
      Spacer()
    }
  }
}

private extension RegularUserProfileEditPage {
  var navigationTitle: some View {
    NavigationTitle("Edit profile")
  }

  var avatarEditor: some View {
    AvatarEditor(photoViewModel: avatarViewModel.photoViewModel)
  }

  var firstNameInput: some View {
    TextFormItem(
      title: "First name",
      hint: "First name",
      input: $profileViewModel.dto.firstName,
      showIcon: true
    )
  }

  var lastNameInput: some View {
    TextFormItem(
      title: "Last name",
      hint: "Last name",
      input: $profileViewModel.dto.lastName,
      showIcon: true
    )
  }

  var usernameInput: some View {
    TextFormItem(
      title: "@Username",
      hint: "Username",
      input: $profileViewModel.dto.username,
      showIcon: true
    )
  }

  var emailInput: some View {
    TextFormItem(
      title: "Email",
      hint: "Email",
      input: $profileViewModel.dto.email,
      showIcon: true
    )
  }
}

private enum Constants {
  static let vSpacing = 24.0
}

#Preview {
  RegularUserProfileEditPage()
}
