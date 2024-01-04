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
    VStack(spacing: ChangePasswordConstants.vSpacing) {
      navigationTitle
      Spacer()
      newPasswordInput
      newPasswordConfirmInput
      nextButton
      Spacer()
    }
  }
}

private extension NewPasswordPage {
  var navigationTitle: some View {
    NavigationTitle("Change password", divider: true)
  }

  @ViewBuilder
  var newPasswordInput: some View {
    let title = "New password"
    TextFormItem(title: title, hint: "Password", input: $newPassword)
  }

  @ViewBuilder
  var newPasswordConfirmInput: some View {
    let title = "New password confirm"
    TextFormItem(title: title, hint: "Password", input: $newPasswordConfirm)
  }

  var nextButton: some View {
    PrimaryColorButton(text: "Next") {
      print("next button tapped")
    }
  }
}

#Preview {
  NewPasswordPage()
}
