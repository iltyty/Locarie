//
//  RegularUserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import Kingfisher
import SwiftUI

struct RegularUserProfileEditPage: View {
  @State private var loading = false

  @FocusState private var focusField: Field?

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  @StateObject private var avatarVM = AvatarUploadViewModel()
  @StateObject private var profileGetVM = ProfileGetViewModel()
  @StateObject private var profileUpdateVM = ProfileUpdateViewModel()

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Edit profile", right: saveButton, divider: true)
      VStack {
        ScrollView {
          AvatarEditor(photoVM: avatarVM.photoViewModel).padding(.vertical, Constants.avatarVPadding)
          VStack(spacing: Constants.vSpacing) {
            firstNameInput
            lastNameInput
            usernameInput
          }
          .padding(.horizontal)
        }
        .keyboardAdaptive()
      }
      .keyboardDismissable(focus: $focusField)

      Spacer()
    }
    .loadingIndicator(loading: $loading)
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
  var saveButton: some View {
    Button("Save") { updateProfile() }
      .disabled(!profileUpdateVM.isFormValid)
      .fontWeight(.bold)
      .foregroundStyle(profileUpdateVM.isFormValid ? LocarieColor.primary : LocarieColor.greyDark)
  }

  var firstNameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "First name",
      hint: "First name",
      note: "Maximum 25 letters.",
      text: $profileUpdateVM.dto.firstName
    )
    .focused($focusField, equals: .firstName)
  }

  var lastNameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "Last name",
      hint: "Last name",
      note: "Maximum 25 letters.",
      text: $profileUpdateVM.dto.lastName
    )
    .focused($focusField, equals: .lastName)
  }

  var usernameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "@Username",
      hint: "Username",
      note: "Only letters, numbers, and full stops are allowed.",
      text: $profileUpdateVM.dto.username
    )
    .focused($focusField, equals: .username)
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
    switch state {
    case .loading:
      loading = true
    case let .finished(avatarUrl):
      loading = false
      guard let avatarUrl else { return }
      ImageCache.default.removeImage(forKey: avatarUrl)
      cacheVM.setAvatarUrl(avatarUrl)
    default:
      loading = false
    }
  }

  func handleProfileUpdateViewModelStateChange(
    _ state: ProfileUpdateViewModel.State
  ) {
    switch state {
    case .loading:
      loading = true
    case let .finished(dto):
      handleProfileUpdateFinished(dto)
    case let .failed(error):
      handleProfileUpdateError(error)
    default:
      loading = false
    }
  }

  func handleProfileUpdateFinished(_ dto: UserDto?) {
    loading = false
    if let dto {
      cacheVM.setUserInfo(dto)
    }
  }

  func handleProfileUpdateError(_ error: NetworkError) {
    loading = false
    print(error)
  }
}

private enum Field {
  case firstName, lastName, username
}

private enum Constants {
  static let vSpacing: CGFloat = 16
  static let avatarVPadding: CGFloat = 50
}

#Preview {
  RegularUserProfileEditPage()
}
