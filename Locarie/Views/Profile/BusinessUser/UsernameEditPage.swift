//
//  UsernameEditPage.swift
//  Locarie
//
//  Created by qiu on 2024/11/11.
//

import SwiftUI

struct UsernameEditPage: View {
  private let cacheVM = LocalCacheViewModel.shared
  
  @ObservedObject var profileUpdateVM: ProfileUpdateViewModel
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Username", right: saveButton, divider: true)
      Spacer()
      TextEditFormItemWithBlockTitleAndStatus(
        title: "Username",
        hint: "Username",
        note: "Only letters, numbers, and full stops are allowed.",
        valid: profileUpdateVM.isUsernameValid,
        text: $profileUpdateVM.dto.username
      )
      .padding(.horizontal, 16)
      Spacer()
      Spacer()
    }
    .onReceive(profileUpdateVM.$state) { state in
      switch state {
      case let .finished(dto):
        if let dto {
          cacheVM.setUserInfo(dto)
          cacheVM.setProfileComplete(dto.isProfileComplete)
          profileUpdateVM.state = .idle
        }
      default: return
      }
    }
  }
  
  private var saveButton: some View {
    Button("Save") { updateProfile() }
      .disabled(!profileUpdateVM.isFormValid)
      .fontWeight(.bold)
      .foregroundStyle(profileUpdateVM.isFormValid ? LocarieColor.primary : LocarieColor.greyDark)
  }
}

private extension UsernameEditPage {
  func updateProfile() {
    let userId = cacheVM.getUserId()
    profileUpdateVM.updateProfile(userId: userId)
    dismiss()
  }
}
