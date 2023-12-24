//
//  NewLoginPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct NewLoginPage: View {
  @StateObject private var authViewModel = LoginViewModel()
  @StateObject private var cacheViewModel = LocalCacheViewModel()

  @State private var isLoading = false
  @State private var isAlertShowing = false
  @State private var alertTitle = AlertTitle.none

  var body: some View {
    content
      .disabled(isLoading)
      .overlay(loadingOverlayView)
      .alert(alertTitle.rawValue, isPresented: $isAlertShowing) {
        Button("OK") {}
      }
  }

  var content: some View {
    NavigationView {
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
    formItemBuilder(
      hint: "Email",
      input: $authViewModel.dto.email,
      isSecure: false
    )
  }

  var passwordInput: some View {
    formItemBuilder(
      hint: "Password",
      input: $authViewModel.dto.password,
      isSecure: true
    )
  }

  var forgotPassword: some View {
    NavigationLink {
      EmptyView()
    } label: {
      HStack {
        Spacer()
        Text("Forgot password?")
          .padding(.horizontal)
      }
    }
  }

  var loginButton: some View {
    primaryButtonBuilder(text: "Log in") {
      login()
    }
    .disabled(!authViewModel.isFormValid)
    .opacity(authViewModel.isFormValid ? 1 : Constants.buttonInvalidOpacity)
  }

  var orText: some View {
    Text("or").foregroundStyle(.secondary)
  }

  var googleButton: some View {
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
    return whiteButtonBuilder(label: label) {
      print("google button tapped")
    }
  }

  var signUpText: some View {
    HStack {
      Text("Don't have an account?")
        .foregroundStyle(.secondary)
      NavigationLink {
        EmptyView()
      } label: {
        Text("Sign up")
      }
    }
  }
}

extension NewLoginPage {
  private func login() {
    Task {
      authViewModel.login(
        onSuccess: handleLoginSuccess,
        onFailure: handleLoginFailure,
        onError: handleLoginError
      )
    }
  }

  private func handleLoginSuccess(_ response: Response) {
    isLoading = false
    if let info = response.data {
      cacheViewModel.setUserInfo(info)
    }
    alertTitle = .success
    isAlertShowing = true
  }

  private func handleLoginFailure(_ response: Response) {
    isLoading = false
    if let code = ResultCode(rawValue: response.status) {
      switch code {
      case .incorrectCredentials:
        alertTitle = .incorrectCredential
      default:
        alertTitle = .unknownError
      }
    } else {
      alertTitle = .unknownError
    }
    isAlertShowing = true
  }

  private func handleLoginError(_ error: Error) {
    debugPrint(error)
    isLoading = false
    alertTitle = .unknownError
    isAlertShowing = true
  }
}

private enum AlertTitle: String {
  case success = "Login success"
  case incorrectCredential = "Incorret email or password"
  case unknownError = "Something went wrong, please try again later"
  case none = ""
}

private enum Constants {
  static let locarieIconSize = 64.0
  static let googleIconSize = 32.0
  static let formItemSpacing = 15.0
  static let loadingBackgroundOpacity = 0.05
  static let buttonInvalidOpacity = 0.5
}

private typealias Response = ResponseDto<LoginResponseDto>

#Preview {
  NewLoginPage()
}
