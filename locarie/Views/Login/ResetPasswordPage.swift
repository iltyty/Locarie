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

  private var navigationTitle: some View {
    Text("Reset Password")
      .font(.headline)
      .fontWeight(.bold)
  }

  private var hint: some View {
    Text("Type in your email to receive an email link to reset your password. ")
      .padding(.horizontal)
  }

  private var emailInput: some View {
    TextFormItem(hint: "Email", input: $email)
  }

  private var nextButton: some View {
    Button {
      print("next button tapped")
    } label: {
      primaryColorFormItemBuilder(text: "Next")
    }
  }
}

private enum Constants {
  static let spacing = 15.0
}

#Preview {
  ResetPasswordPage()
}
