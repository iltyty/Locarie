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
    VStack {
      navigationBar
      content
    }
  }

  private var content: some View {
    VStack(spacing: Constants.spacing) {
      hint
      emailInput
      nextButton
      Spacer()
    }
  }

  private var navigationBar: some View {
    NavigationBar("Reset Password", divider: true, padding: true)
  }

  private var hint: some View {
    Text("Type in your email to receive an email link to reset your password. ")
      .fontWeight(.semibold)
      .padding(.horizontal)
  }

  private var emailInput: some View {
    TextEditFormItemWithNoTitle(hint: "Email", text: $email)
      .padding(.horizontal)
  }

  private var nextButton: some View {
    Button {
      print("next button tapped")
    } label: {
      BackgroundButtonFormItem(title: "Next", isFullWidth: false)
    }
  }
}

private enum Constants {
  static let spacing = 15.0
}

#Preview {
  ResetPasswordPage()
}
