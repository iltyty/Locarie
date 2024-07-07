//
//  NewPasswordPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct NewPasswordPage: View {
  @State private var loading = false
  @State private var alertTitle = ""
  @State private var isAlertPresented = false

  @StateObject private var authVM = AuthViewModel()
  @StateObject private var newPasswordVM = NewPasswordViewModel()

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      NavigationBar("Change password", divider: true, padding: true)
      VStack(alignment: .leading, spacing: 16) {
        newPasswordInput
        newPasswordConfirmInput
        nextButton
      }
      .padding(.horizontal, 16)
      Spacer()
    }
    .loadingIndicator(loading: $loading)
    .alert(alertTitle, isPresented: $isAlertPresented) { Button("OK") {} }
    .onReceive(authVM.$state) { state in
      switch state {
      case .loading: loading = true
      case .failed:
        loading = false
        displayAlert("Something went wrong, please try again later.")
      case .resetPasswordFinished:
        loading = false
        displayAlert("Reset password succeed.")
      default: loading = false
      }
    }
  }

  private func displayAlert(_ title: String) {
    alertTitle = title
    isAlertPresented = true
  }
}

private extension NewPasswordPage {
  @ViewBuilder
  var newPasswordInput: some View {
    let title = "New password"
    TextEditFormItemWithBlockTitleAndStatus(
      title: title,
      hint: "Password",
      note: "Minimum 8 characters or numbers.",
      valid: newPasswordVM.isPasswordValid,
      isSecure: true,
      text: $newPasswordVM.password
    )
  }

  @ViewBuilder
  var newPasswordConfirmInput: some View {
    let title = "Confirm new password"
    TextEditFormItemWithBlockTitleAndStatus(
      title: title,
      hint: "Password",
      valid: newPasswordVM.isConfirmPasswordValid,
      isSecure: true,
      text: $newPasswordVM.confirmPassword
    )
  }

  var nextButton: some View {
    HStack {
      Spacer()
      BackgroundButtonFormItem(title: "Done", isFullWidth: false)
        .disabled(newPasswordVM.isFormValid)
        .opacity(newPasswordVM.isFormValid ? 1 : 0.5)
        .onTapGesture {
          authVM.resetPassword(email: cacheVM.cache.email, password: newPasswordVM.password)
        }
      Spacer()
    }
  }
}

#Preview {
  NewPasswordPage()
}
