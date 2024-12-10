//
//  BusinessNameEditPage.swift
//  Locarie
//
//  Created by qiu on 2024/11/11.
//

import SwiftUI

struct BusinessNameEditPage: View {
  @ObservedObject var profileUpdateVM: ProfileUpdateViewModel
  @Environment(\.dismiss) private var dismiss

  private let cacheVM = LocalCacheViewModel.shared
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Business name", right: saveButton, divider: true)
      Spacer()
      TextEditFormItemWithBlockTitleAndStatus(
        title: "Business name",
        hint: "Business name",
        note: "Maximum 25 letters.",
        valid: profileUpdateVM.isBusinessNameValid,
        text: $profileUpdateVM.dto.businessName
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
      .fontWeight(.bold)
      .foregroundStyle(LocarieColor.primary)
  }
}

private extension BusinessNameEditPage {
  func updateProfile() {
    let userId = cacheVM.getUserId()
    profileUpdateVM.updateProfile(userId: userId)
    dismiss()
  }
}
