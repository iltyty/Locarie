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
    VStack(alignment: .leading, spacing: 16) {
      NavigationBar("Change password", divider: true, padding: true)
      newPasswordInput
      passwordNote
      newPasswordConfirmInput
      nextButton
      Spacer()
    }
  }
}

private extension NewPasswordPage {
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

#Preview {
  NewPasswordPage()
}
