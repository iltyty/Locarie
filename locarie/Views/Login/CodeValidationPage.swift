//
//  CodeValidationPage.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import SwiftUI

struct CodeValidationPage: View {
  let email: String

  @State private var code = ""
  @State private var loading = false
  @State private var alertTitle = ""
  @State private var presentingAlert = false

  @StateObject private var authVM = AuthViewModel()
  @ObservedObject private var router = Router.shared

  var body: some View {
    VStack {
      navigationBar
      content
    }
    .alert(alertTitle, isPresented: $presentingAlert, actions: {
      Button("OK") {}
    })
    .overlay(LoadingView($loading))
    .onReceive(authVM.$state) { state in
      switch state {
      case .loading: loading = true
      case .validateForgotPasswordFinished:
        loading = false
        router.navigation(to: Router.StringDestination.resetPassword(email))
      case let .failed(error):
        loading = false
        if error.initialError != nil {
          alertTitle = ErrorMessage.network.rawValue
        } else if let backendError = error.backendError {
          alertTitle = backendError.message
        } else {
          alertTitle = "Code incorrect"
        }
        presentingAlert = true
      default: loading = false
      }
    }
  }
}

private extension CodeValidationPage {
  var content: some View {
    VStack(spacing: Constants.vSpacing) {
      hint
      codeInput
      nextButton
      Spacer()
    }
  }

  var navigationBar: some View {
    NavigationBar("Reset Password", divider: true, padding: true)
  }

  private var hint: some View {
    Text("Type in the validation code sent to your email")
      .fontWeight(.semibold)
      .padding(.horizontal)
  }

  private var codeInput: some View {
    TextEditFormItemWithNoTitle(hint: "Code", text: $code)
      .padding(.horizontal)
  }

  private var nextButton: some View {
    Button {
      authVM.validateForgotPassword(email: email, code: code)
    } label: {
      BackgroundButtonFormItem(title: "Next", isFullWidth: false)
    }
    .disabled(code.isEmpty)
    .opacity(code.isEmpty ? 0.5 : 1)
  }
}

private enum Constants {
  static let vSpacing = 15.0
}

#Preview {
  CodeValidationPage(email: "")
}
