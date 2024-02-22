//
//  NewPasswordPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct NewPasswordPage: View {
  @State var newPassword = ""
  @State var newPasswordConfirm = ""

  var body: some View {
    VStack(alignment: .leading, spacing: ChangePasswordConstants.vSpacing) {
      navigationTitle
      input
      nextButton
      Spacer()
    }
  }
}

private extension NewPasswordPage {
  var navigationTitle: some View {
    NavigationBar("Change password", divider: true, padding: true)
  }

  var input: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      newPasswordInput
      passwordNote
      newPasswordConfirmInput
    }
  }

  @ViewBuilder
  var newPasswordInput: some View {
    let title = "New password"
    TextEditFormItemWithBlockTitle(
      title: title,
      hint: "Password",
      text: $newPassword
    )
    .padding(.horizontal)
  }

  var passwordNote: some View {
    Text("Minimum 8 characters or numbers.")
      .font(.footnote)
      .foregroundStyle(.secondary)
      .padding(.leading)
      .padding(.horizontal)
  }

  @ViewBuilder
  var newPasswordConfirmInput: some View {
    let title = "Confirm new password"
    TextEditFormItemWithBlockTitle(
      title: title,
      hint: "Password",
      text: $newPasswordConfirm
    )
    .padding(.horizontal)
  }

  var nextButton: some View {
    HStack {
      Spacer()
      BackgroundButtonFormItem(title: "Done", isFullWidth: false)
      Spacer()
    }
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 12
}

#Preview {
  NewPasswordPage()
}
