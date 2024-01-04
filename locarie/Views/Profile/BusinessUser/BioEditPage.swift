//
//  BioEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct BioEditPage: View {
  @Binding var bio: String

  @StateObject var bioEditViewModel = TextEditViewModel(limit: 150)

  @State private var hint = "Bio..."

  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      navigationTitle
      bioEditor
    }
  }
}

private extension BioEditPage {
  var navigationTitle: some View {
    NavigationTitle("Edit Bio", right: doneButton)
  }

  var doneButton: some View {
    Button {
      bio = bioEditViewModel.text
      dismiss()
    } label: {
      Text("Done")
        .fontWeight(.bold)
        .foregroundStyle(Color.locariePrimary)
    }
  }

  var bioEditor: some View {
    TextEditorPlus(hint: "Bio...", viewModel: bioEditViewModel)
  }
}

private enum Constants {
  static let vSpacing = 24.0
}

#Preview {
  BioEditPage(bio: .constant(""))
}
