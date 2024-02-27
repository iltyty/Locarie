//
//  ResetPasswordPage.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import SwiftUI

struct ResetPasswordPage: View {
  let email: String

  @State private var loading = false
  @State private var alertTitle = ""
  @State private var presentingAlert = false

  @StateObject private var authVM = AuthViewModel()
  @StateObject private var loginVM = LoginViewModel()
  @StateObject private var newPasswordVM = NewPasswordViewModel()
  @ObservedObject private var router = Router.shared
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack {
      navigationBar
      content
    }
    .alert(alertTitle, isPresented: $presentingAlert) {
      Button("OK") {}
    }
    .overlay(LoadingView($loading))
    .onReceive(authVM.$state) { state in handleAuthStateChange(state) }
    .onReceive(loginVM.$state) { state in handleLoginStateChange(state) }
  }

  private func handleAuthStateChange(_ state: AuthViewModel.State) {
    switch state {
    case .loading: loading = true
    case .resetPasswordFinished:
      loginVM.setDto(email: email, password: newPasswordVM.password)
      loginVM.login()
    case let .failed(error):
      loading = false
      if error.initialError != nil {
        alertTitle = ErrorMessage.network.rawValue
      } else if let backendError = error.backendError {
        alertTitle = backendError.message
      } else {
        alertTitle = ErrorMessage.unknown.rawValue
      }
      presentingAlert = true
    default: loading = false
    }
  }

  private func handleLoginStateChange(_ state: LoginViewModel.State) {
    switch state {
    case .loading: loading = true
    case let .finished(cache):
      if let cache {
        cacheVM.setUserCache(cache)
      }
      router.navigateToRoot()
    case let .failed(error):
      if error.initialError != nil {
        alertTitle = ErrorMessage.network.rawValue
      } else if let backendError = error.backendError {
        alertTitle = backendError.message
      } else {
        alertTitle = ErrorMessage.unknown.rawValue
      }
      presentingAlert = true
    default: loading = false
    }
  }
}

private extension ResetPasswordPage {
  var content: some View {
    VStack(spacing: Constants.vSpacing) {
      passwordInput
      confirmPasswordInput
      confirmButton
      Spacer()
    }
  }

  var navigationBar: some View {
    NavigationBar("New Password", divider: true, padding: true)
  }

  var passwordInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "New password", hint: "New password", isSecure: true, text: $newPasswordVM.password
    )
    .padding(.horizontal)
  }

  var confirmPasswordInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "Confirm new password", hint: "Confirm new password", isSecure: true, text: $newPasswordVM.confirmPassword
    )
    .padding(.horizontal)
  }

  var confirmButton: some View {
    Button {
      authVM.resetPassword(email: email, password: newPasswordVM.password)
    } label: {
      BackgroundButtonFormItem(title: "Confirm", isFullWidth: false)
    }
    .disabled(isButtonDisabled)
    .opacity(isButtonDisabled ? 0.5 : 1)
  }

  var isButtonDisabled: Bool {
    !newPasswordVM.isFormValid
  }
}

private enum Constants {
  static let vSpacing = 15.0
}

#Preview {
  ResetPasswordPage(email: "")
}
