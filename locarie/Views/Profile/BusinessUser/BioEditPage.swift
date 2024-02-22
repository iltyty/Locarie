//
//  BioEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct BioEditPage: View {
  @Binding var bio: String

  @StateObject var bioEditViewModel =
    TextEditViewModel(limit: Constants.wordLimit)

  @State private var hint = "Bio..."

  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      navigationTitle
      bioEditor
    }
    .onAppear {
      bioEditViewModel.text = bio
    }
  }
}

private extension BioEditPage {
  var navigationTitle: some View {
    NavigationBar("Edit Bio", right: doneButton, divider: true)
  }

  var doneButton: some View {
    Button("Done") {
      bio = bioEditViewModel.text
      dismiss()
    }
    .fontWeight(.bold)
    .foregroundStyle(Color.locariePrimary)
  }

  var bioEditor: some View {
    TextEditorPlus(viewModel: bioEditViewModel, hint: "Bio...")
  }
}

private enum Constants {
  static let vSpacing = 24.0
  static let wordLimit = 150
}

#Preview {
  BioEditPage(bio: .constant(""))
}
