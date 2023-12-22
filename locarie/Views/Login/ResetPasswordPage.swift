//
//  ResetPasswordPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct ResetPasswordPage: View {
  @State var email = ""

  var body: some View {
    VStack(spacing: Constants.spacing) {
      navigationTitle
      Spacer()
      hint
      emailInput
      nextButton
      Spacer()
    }
  }

  var navigationTitle: some View {
    Text("Reset Password")
      .font(.headline)
      .fontWeight(.bold)
  }

  var hint: some View {
    Text("Type in your email to receive an email link to reset your password. ")
      .padding(.horizontal)
  }

  var emailInput: some View {
    formItemBuilder(hint: "Email", input: $email, isSecure: false)
  }

  var nextButton: some View {
    primaryButtonBuilder(text: "Next") {
      print("next button tapped")
    }
  }
}

private enum Constants {
  static let spacing = 15.0
}

#Preview {
  ResetPasswordPage()
}
