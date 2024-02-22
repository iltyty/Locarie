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
    VStack(spacing: ChangePasswordConstants.vSpacing) {
      navigationBar
      passwordInput
      nextButton
      Spacer()
    }
  }
}

private extension ChangePasswordPage {
  var navigationBar: some View {
    NavigationBar("Change password", divider: true, padding: true)
  }

  @ViewBuilder
  var passwordInput: some View {
    let title = "Type in your current password"
    TextEditFormItemWithBlockTitle(
      title: title,
      hint: "Password",
      text: $password
    )
    .padding(.horizontal)
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
