//
//  BioEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct BioEditPage: View {
  @Binding var bio: String

  @Environment(\.dismiss) var dismiss

  @ObservedObject private var bioEditViewModel = BioEditViewModel()

  @State private var hint = "Bio..."

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      navigationTitle
      bioEditor
      remainingEditCount
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
    ZStack(alignment: .topLeading) {
      if bioEditViewModel.text.isEmpty {
        TextEditor(text: $hint)
          .foregroundStyle(.secondary)
          .padding(.horizontal)
          .disabled(true)
      }
      TextEditor(text: $bioEditViewModel.text)
        .padding(.horizontal)
        .opacity(bioEditViewModel.text.isEmpty ? 0.25 : 1)
    }
  }

  var remainingEditCount: some View {
    HStack {
      Spacer()
      Text("\(bioEditViewModel.remainingCount)")
        .padding()
    }
  }
}

private enum Constants {
  static let vSpacing = 24.0
}

#Preview {
  BioEditPage(bio: .constant(""))
}
