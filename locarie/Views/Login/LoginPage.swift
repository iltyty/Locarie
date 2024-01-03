//
//  LoginPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct LoginPage: View {
  @Binding var path: [Route]

  @StateObject private var loginViewModel = LoginViewModel()
  @StateObject private var cacheViewModel = LocalCacheViewModel()

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
    case let .finished(info):
      isLoading = false
      handleLoginFinished(info: info)
    case let .failed(error):
      isLoading = false
      handleNetworkError(error)
    default:
      return
    }
  }

  private func handleLoginFinished(info: UserInfo?) {
    guard let info else { return }
    cacheViewModel.setUserInfo(info)
    backToRoot()
  }

  private func handleNetworkError(_ error: NetworkError) {
    isLoading = false
    if let backendError = error.backendError {
      alertTitle = backendError.message
    } else if let initialError = error.initialError {
      alertTitle = initialError.localizedDescription
    } else {
      alertTitle = "Something went wrong, please try again later"
    }
    isAlertShowing = true
  }

  private func backToRoot() {
    path.removeAll()
  }
}

private extension LoginPage {
  var content: some View {
    VStack(spacing: Constants.formItemSpacing) {
      Spacer()
      locarieIcon
      Spacer()
      emailInput
      passwordInput
      forgotPassword
      loginButton
      orText
      googleButton
      Spacer()
      signUpText
      Spacer()
    }
  }

  var loadingOverlayView: some View {
    isLoading ? loadingView : nil
  }

  var loadingView: some View {
    ProgressView()
      .progressViewStyle(.circular)
      .background(.white.opacity(Constants.loadingBackgroundOpacity))
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
    TextFormItem(hint: "Email", input: $loginViewModel.dto.email)
  }

  var passwordInput: some View {
    SecureFormItem(hint: "Password", input: $loginViewModel.dto.password)
  }

  var forgotPassword: some View {
    NavigationLink(value: Route.forgotPassword) {
      HStack {
        Spacer()
        Text("Forgot password?")
          .padding(.horizontal)
      }
    }
  }

  var loginButton: some View {
    Button {
      loginViewModel.login()
    } label: {
      primaryColorFormItemBuilder(text: "Log in")
    }
    .disabled(isLoginButtonDisabled)
    .opacity(loginButtonOpacity)
  }

  var orText: some View {
    Text("or").foregroundStyle(.secondary)
  }

  @ViewBuilder var googleButton: some View {
    let label = Label {
      Text("Continue with Google")
    } icon: {
      Image("GoogleLogo")
        .resizable()
        .frame(
          width: Constants.googleIconSize,
          height: Constants.googleIconSize
        )
    }
    Button {
      print("google button tapped")
    } label: {
      backgroundColorFormItemBuilder(label: label)
    }
    .tint(.primary)
  }

  var signUpText: some View {
    HStack {
      Text("Don't have an account?")
        .foregroundStyle(.secondary)
      NavigationLink(value: Route.regularRegister) {
        Text("Sign up")
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
  static let loadingBackgroundOpacity = 0.05
  static let buttonDisabledOpacity = 0.5
}

#Preview {
  LoginPage(path: .constant([]))
}
