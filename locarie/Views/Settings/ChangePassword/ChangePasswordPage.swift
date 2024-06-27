//
//  ChangePasswordPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct ChangePasswordPage: View {
  @State var password = ""

  var body: some View {
    VStack(spacing: 16) {
      NavigationBar("Change password", divider: true, padding: true)
      passwordInput
      forgotPassword
      nextButton
      Spacer()
    }
  }
}

private extension ChangePasswordPage {
  @ViewBuilder
  var passwordInput: some View {
    let title = "Type in your current password"
    TextEditFormItemWithBlockTitle(
      title: title,
      hint: "Password",
      text: $password
    )
    .padding(.horizontal, 16)
  }

  var forgotPassword: some View {
    HStack {
      Spacer()
      NavigationLink {
        ForgotPasswordPage()
      } label: {
        Text("Forgotten password")
          .foregroundStyle(LocarieColor.blue)
          .padding(.horizontal, 16)
      }
    }
  }

  var nextButton: some View {
    NavigationLink {
      NewPasswordPage()
    } label: {
      StrokeButtonFormItem(title: "Next", isFullWidth: false)
    }
  }
}

#Preview {
  ChangePasswordPage()
}
