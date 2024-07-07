//
//  ChangePasswordPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct ChangePasswordPage: View {
  @State private var password = ""
  @State private var loading = false
  @State private var isAlertPresented = false

  @State private var isPasswordValid = false

  @StateObject private var authVM = AuthViewModel()

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Change password", divider: true, padding: true)
      passwordInput
      forgotPassword
      nextButton
      Spacer()
    }
    .loadingIndicator(loading: $loading)
    .alert("Incorrect password", isPresented: $isAlertPresented) { Button("OK") {} }
    .onChange(of: password) { _ in
      isPasswordValid = password.wholeMatch(of: Regexes.password) != nil
    }
    .onReceive(authVM.$state) { state in
      switch state {
      case .loading: loading = true
      case let .validatePasswordFinished(succeed):
        loading = false
        if succeed {
          Router.shared.navigate(to: Router.Destination.newPassword)
        } else {
          isAlertPresented = true
        }
      default: loading = false
      }
    }
  }
}

private extension ChangePasswordPage {
  @ViewBuilder
  var passwordInput: some View {
    let title = "Type in your current password"
    TextEditFormItemWithBlockTitleAndStatus(
      title: title,
      hint: "Password",
      note: "Minimum 8 characters or numbers.",
      valid: isPasswordValid,
      isSecure: true,
      text: $password
    )
    .padding(.horizontal, 16)
    .padding(.bottom, 14)
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
    .padding(.bottom, 14)
  }

  var nextButton: some View {
    StrokeButtonFormItem(
      title: "Next",
      isFullWidth: false,
      color: isPasswordValid ? LocarieColor.primary : LocarieColor.greyDark
    )
    .disabled(!isPasswordValid)
    .onTapGesture {
      authVM.validatePassword(email: cacheVM.cache.email, password: password)
    }
  }
}

#Preview {
  ChangePasswordPage()
}
