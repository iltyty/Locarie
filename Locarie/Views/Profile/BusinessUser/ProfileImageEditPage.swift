//
//  ProfileImageEditPage.swift
//  Locarie
//
//  Created by qiu on 2024/11/16.
//

import SwiftUI

struct ProfileImageEditPage: View {
  @ObservedObject var avatarVM: AvatarUploadViewModel
  
  @State private var modified = false
  
  @Environment(\.dismiss) private var dismiss
  
  private let cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack {
      NavigationBar("Profile Image", right: saveButton)
      Spacer()
      HStack {
        Spacer()
        AvatarEditor(photoVM: avatarVM.photoViewModel, modified: $modified)
        Spacer()
      }
      Spacer()
    }
  }
  
  private var saveButton: some View {
    Button("Save") { updateProfile() }
      .foregroundStyle(LocarieColor.primary)
      .fontWeight(.bold)
  }
  
  private func updateProfile() {
    if !modified {
      return
    }
    let userId = cacheVM.getUserId()
    avatarVM.upload(userId: userId)
    dismiss()
  }
}
