//
//  RegularUserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct RegularUserProfileEditPage: View {
  @Environment(\.dismiss) var dismiss

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  @StateObject private var avatarVM = AvatarUploadViewModel()
  @StateObject private var profileGetVM = ProfileGetViewModel()
  @StateObject private var profileUpdateVM = ProfileUpdateViewModel()

  var body: some View {
    VStack {
      navigationBar
      avatarEditor
      VStack(spacing: Constants.vSpacing) {
        firstNameInput
        lastNameInput
        usernameInput
      }
      .padding(.horizontal)
      Spacer()
    }
    .onAppear {
      profileGetVM.getProfile(userId: cacheVM.getUserId())
    }
    .onReceive(avatarVM.$state) { state in
      handleAvatarUpdateStateChange(state)
    }
    .onReceive(profileGetVM.$state) { state in
      handleProfileGetViewModelStateChange(state)
    }
    .onReceive(profileUpdateVM.$state) { state in
      handleProfileUpdateViewModelStateChange(state)
    }
  }
}

private extension RegularUserProfileEditPage {
  var navigationBar: some View {
    NavigationBar("Edit profile", right: saveButton, divider: true)
  }

  var saveButton: some View {
    Button("Save") {
      updateProfile()
    }
    .fontWeight(.bold)
    .foregroundStyle(Color.locariePrimary)
  }

  var avatarEditor: some View {
    AvatarEditor(photoViewModel: avatarVM.photoViewModel)
      .padding(.vertical, Constants.avatarVPadding)
  }

  var firstNameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "First name",
      hint: "First name",
      text: $profileUpdateVM.dto.firstName
    )
  }

  var lastNameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "Last name",
      hint: "Last name",
      text: $profileUpdateVM.dto.lastName
    )
  }

  var usernameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "@Username",
      hint: "Username",
      text: $profileUpdateVM.dto.username
    )
  }
}

private extension RegularUserProfileEditPage {
  func updateProfile() {
    let userId = cacheVM.getUserId()
    avatarVM.upload(userId: userId)
    profileUpdateVM.updateProfile(userId: userId)
  }

  func handleProfileGetViewModelStateChange(
    _ state: ProfileGetViewModel.State
  ) {
    if case .finished = state {
      let dto = profileGetVM.dto
      profileUpdateVM.dto = dto
    }
  }

  func handleAvatarUpdateStateChange(
    _ state: AvatarUploadViewModel.State
  ) {
    if case let .finished(avatarUrl) = state {
      guard let avatarUrl else { return }
      cacheVM.setAvatarUrl(avatarUrl)
    }
  }

  func handleProfileUpdateViewModelStateChange(
    _ state: ProfileUpdateViewModel.State
  ) {
    switch state {
    case let .finished(dto):
      handleProfileUpdateFinished(dto)
    case let .failed(error):
      handleProfileUpdateError(error)
    default: return
    }
  }

  func handleProfileUpdateFinished(_ dto: UserDto?) {
    if let dto {
      print(dto)
      cacheVM.setUserInfo(dto)
    }
    dismiss()
  }

  func handleProfileUpdateError(_ error: NetworkError) {
    print(error)
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16
  static let avatarVPadding: CGFloat = 50
}

#Preview {
  RegularUserProfileEditPage()
}
