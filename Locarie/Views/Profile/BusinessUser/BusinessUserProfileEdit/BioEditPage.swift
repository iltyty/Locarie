//
//  BioEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct BioEditPage: View {
  @ObservedObject var profileUpdateVM: ProfileUpdateViewModel

  @State private var hint = "Bio"
  @Environment(\.dismiss) private var dismiss
  @StateObject private  var bioEditViewModel = TextEditViewModel(limit: Constants.wordLimit)
  
  private let cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      navigationTitle
      bioEditor
    }
    .onAppear {
      bioEditViewModel.text = profileUpdateVM.dto.introduction
    }
  }
}

private extension BioEditPage {
  var navigationTitle: some View {
    NavigationBar("Bio", right: doneButton, divider: true)
  }

  var doneButton: some View {
    Button("Done") {
      profileUpdateVM.dto.introduction = bioEditViewModel.text
      profileUpdateVM.updateProfile(userId: cacheVM.getUserId())
      dismiss()
    }
    .fontWeight(.bold)
    .foregroundStyle(Color.locariePrimary)
  }

  var bioEditor: some View {
    TextEditorPlusWithLimit(viewModel: bioEditViewModel, hint: "Bio...")
  }
}

private enum Constants {
  static let vSpacing = 24.0
  static let wordLimit = 500
}
