//
//  ForgotPasswordPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct ForgotPasswordPage: View {
  @State private var email = ""
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
      case .forgotPasswordFinished:
        loading = false
        router.navigate(to: Router.StringDestination.codeValidation(email))
      case let .failed(error):
        loading = false
        if error.initialError != nil {
          alertTitle = ErrorMessage.network.rawValue
        } else if let backendError = error.backendError, backendError.code == .userNotFound {
          alertTitle = "Email not exist"
        } else {
          alertTitle = ErrorMessage.unknown.rawValue
        }
        presentingAlert = true
      default: loading = false
      }
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
    Text("Type in your email to receive a validation code to reset your password. ")
      .fontWeight(.semibold)
      .padding(.horizontal)
  }

  private var emailInput: some View {
    TextEditFormItemWithNoTitle(hint: "Email", text: $email)
      .padding(.horizontal)
  }

  private var nextButton: some View {
    Button {
      authVM.forgotPassword(email: email)
    } label: {
      BackgroundButtonFormItem(title: "Next", isFullWidth: false)
    }
    .disabled(email.isEmpty)
    .opacity(email.isEmpty ? 0.5 : 1)
  }
}

private enum Constants {
  static let spacing = 15.0
}

#Preview {
  ForgotPasswordPage()
}
