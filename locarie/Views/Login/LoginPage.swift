//
//  LoginPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct LoginPage: View {
  @ObservedObject var router = Router.shared

  @StateObject private var loginViewModel = LoginViewModel()
  @StateObject private var cacheViewModel = LocalCacheViewModel.shared

  @State private var isLoading = false
  @State private var isAlertShowing = false
  @State private var alertTitle = ""

  var body: some View {
    content
      .disabled(isLoading)
      .overlay(loadingOverlayView)
      .alert(alertTitle, isPresented: $isAlertShowing) {}
      .onReceive(loginViewModel.$state) { state in
        handleLoginStateChange(state)
      }
  }

  private func handleLoginStateChange(_ state: LoginViewModel.State) {
    switch state {
    case let .finished(cache):
      isLoading = false
      handleLoginFinished(cache: cache)
    case let .failed(error):
      isLoading = false
      handleNetworkError(error)
    default:
      return
    }
  }

  private func handleLoginFinished(cache: UserCache?) {
    guard let cache else { return }
    cacheViewModel.setUserCache(cache)
    router.navigateToRoot()
  }

  private func handleNetworkError(_ error: NetworkError) {
    isLoading = false
    if let backendError = error.backendError {
      alertTitle = backendError.message
    } else if error.initialError != nil {
      alertTitle = ErrorMessage.network.rawValue
    } else {
      alertTitle = ErrorMessage.unknown.rawValue
    }
    isAlertShowing = true
  }
}

private extension LoginPage {
  var content: some View {
    VStack(spacing: Constants.formItemSpacing) {
      navigationBar
      Spacer()
      locarieIcon
      Spacer()
      emailInput
      passwordInput
      forgotPassword
      loginButton
      Spacer()
      signUpText
      Spacer()
    }
  }

  var navigationBar: some View {
    NavigationBar()
  }

  var loadingOverlayView: some View {
    isLoading ? loadingView : nil
  }

  var loadingView: some View {
    ProgressView()
      .progressViewStyle(.circular)
      .background(.white.opacity(GlobalConstants.loadingBgOpacity))
  }

  var locarieIcon: some View {
    HStack {
      Spacer()
      Image("LocarieIcon")
        .resizable()
        .frame(
          width: Constants.locarieIconSize,
          height: Constants.locarieIconSize
        )
      Spacer()
    }
  }

  var emailInput: some View {
    TextEditFormItemWithNoTitle(hint: "Email", text: $loginViewModel.dto.email)
      .padding(.horizontal)
  }

  var passwordInput: some View {
    TextEditFormItemWithNoTitle(
      hint: "Password",
      isSecure: true,
      text: $loginViewModel.dto.password
    )
    .padding(.horizontal)
  }

  var forgotPassword: some View {
    NavigationLink(value: Router.Destination.resetPassword) {
      HStack {
        Spacer()
        Text("Forgotten password")
          .padding(.horizontal)
      }
    }
  }

  var loginButton: some View {
    Button {
      loginViewModel.login()
    } label: {
      BackgroundButtonFormItem(title: "Log in", isFullWidth: false)
    }
    .disabled(isLoginButtonDisabled)
    .opacity(loginButtonOpacity)
  }

  var orText: some View {
    Text("or").foregroundStyle(.secondary)
  }

  var signUpText: some View {
    HStack {
      Text("Don't have an account?")
        .foregroundStyle(.secondary)
      NavigationLink(value: Router.Destination.regularRegister) {
        Text("Sign up").fontWeight(.semibold)
      }
    }
  }

  var isLoginButtonDisabled: Bool {
    !loginViewModel.isFormValid
  }

  var loginButtonOpacity: CGFloat {
    isLoginButtonDisabled ? Constants.buttonDisabledOpacity : 1
  }
}

private enum Constants {
  static let locarieIconSize = 64.0
  static let googleIconSize = 32.0
  static let formItemSpacing = 15.0
  static let buttonDisabledOpacity = 0.5
}

#Preview {
  LoginPage()
}
