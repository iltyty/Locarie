//
//  LinkEditPage.swift
//  Locarie
//
//  Created by qiu on 2024/11/11.
//

import SwiftUI

struct LinkEditPage: View {
  @ObservedObject var profileUpdateVM: ProfileUpdateViewModel
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("First Name", right: saveButton, divider: true)
      Spacer()
      TextEditFormItemWithBlockTitle(title: "Link", hint: "Link", text: $profileUpdateVM.dto.homepageUrl)
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

private extension LinkEditPage {
  func updateProfile() {
    let userId = cacheVM.getUserId()
    profileUpdateVM.updateProfile(userId: userId)
  }
}
