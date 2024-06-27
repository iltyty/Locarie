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

  @StateObject private var authVM = AuthViewModel()

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 16) {
      NavigationBar("Change password", divider: true, padding: true)
      passwordInput
      forgotPassword
      nextButton
      Spacer()
    }
    .loadingIndicator(loading: $loading)
    .alert("Incorrect password", isPresented: $isAlertPresented) { Button("OK") {} }
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
    TextEditFormItemWithBlockTitle(
      title: title,
      hint: "Password",
      text: $password
    )
    .padding(.horizontal, 16)
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
  }

  var nextButton: some View {
    StrokeButtonFormItem(title: "Next", isFullWidth: false)
      .onTapGesture {
        authVM.validatePassword(email: cacheVM.cache.email, password: password)
      }
  }
}

#Preview {
  ChangePasswordPage()
}
