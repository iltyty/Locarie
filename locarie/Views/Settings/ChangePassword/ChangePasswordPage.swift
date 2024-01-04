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
      navigationTitle
      Spacer()
      passwordInput
      nextButton
      Spacer()
    }
  }
}

private extension ChangePasswordPage {
  var navigationTitle: some View {
    NavigationTitle("Change password", divider: true)
  }

  @ViewBuilder
  var passwordInput: some View {
    let title = "Type in your current password"
    TextFormItem(title: title, hint: "Password", input: $password)
  }

  var nextButton: some View {
    PrimaryColorButton(text: "Next") {
      print("next button tapped")
    }
  }
}

#Preview {
  ChangePasswordPage()
}
