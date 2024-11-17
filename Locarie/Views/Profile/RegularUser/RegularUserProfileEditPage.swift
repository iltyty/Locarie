//
//  RegularUserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import Kingfisher
import SwiftUI

struct RegularUserProfileEditPage: View {
  @State private var avatarModified = false
  @State private var presentingAlert = false

  @FocusState private var focusField: Field?

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  @StateObject private var avatarVM = AvatarUploadViewModel()
  @StateObject private var profileGetVM = ProfileGetViewModel()
  @StateObject private var profileUpdateVM = ProfileUpdateViewModel()

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Edit profile", divider: true)
      VStack {
        ScrollView {
          profileImageEditor.padding(.vertical, Constants.avatarVPadding)
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
    .alert("Profile saved", isPresented: $presentingAlert) {
      Button("OK") {}
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
  @ViewBuilder
  var profileImageEditor: some View {
    let url = cacheVM.getAvatarUrl()
    NavigationLink {
      ProfileImageEditPage(avatarVM: avatarVM)
    } label: {
      VStack(spacing: 10) {
        HStack {
          Spacer()
          if !url.isEmpty {
            KFImage(URL(string: url))
              .placeholder { SkeletonView(64, 64, true) }
              .resizable()
              .frame(size: 64)
              .clipShape(Circle())
          } else {
            defaultAvatar(size: 64, isBusiness: cacheVM.isBusinessUser())
          }
          Spacer()
        }
        Text("Edit profile image")
          .font(.custom(GlobalConstants.fontName, size: 14))
          .foregroundStyle(LocarieColor.blue)
      }
    }
  }
  
  @ViewBuilder
  var firstNameInput: some View {
    let text = "First Name"
    NavigationLink {
      FirstNameEditPage(profileUpdateVM: profileUpdateVM)
    } label: {
      LinkFormItemWithInlineTitle(
        title: text,
        hint: text,
        note: "Maximum 25 letters",
        text: $profileUpdateVM.dto.firstName)
      .focused($focusField, equals: .firstName)
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  var lastNameInput: some View {
    let text = "Last Name"
    NavigationLink {
      LastNameEditPage(profileUpdateVM: profileUpdateVM)
    } label: {
      LinkFormItemWithInlineTitle(
        title: text,
        hint: text,
        note: "Maximum 25 letters",
        text: $profileUpdateVM.dto.lastName)
      .focused($focusField, equals: .lastName)
    }
    .buttonStyle(.plain)
  }
  
  @ViewBuilder
  var usernameInput: some View {
    let text = "Username"
    NavigationLink {
      UsernameEditPage(profileUpdateVM: profileUpdateVM)
    } label: {
      LinkFormItemWithInlineTitle(
        title: text,
        hint: text,
        note: "Only letters, numbers, and full stops are allowed.",
        text: $profileUpdateVM.dto.username)
      .focused($focusField, equals: .username)
    }
    .buttonStyle(.plain)
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
    case let .finished(avatarUrl):
      guard let avatarUrl else { return }
      ImageCache.default.removeImage(forKey: avatarUrl)
      cacheVM.setAvatarUrl(avatarUrl)
    default: return
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
      cacheVM.setUserInfo(dto)
      presentingAlert = true
    }
  }

  func handleProfileUpdateError(_ error: NetworkError) {
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
