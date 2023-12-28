//
//  LoginPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct LoginPage: View {
  @StateObject private var loginViewModel = LoginViewModel()
  @StateObject private var cacheViewModel = LocalCacheViewModel()

  @State private var isLoading = false
  @State private var isAlertShowing = false
  @State private var alertTitle = ""

  var body: some View {
    content
      .disabled(isLoading)
      .overlay(loadingOverlayView)
      .alert(alertTitle, isPresented: $isAlertShowing) { Button("OK") {} }
  }

  var content: some View {
    NavigationStack {
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
      input: $loginViewModel.dto.email,
      isSecure: false
    )
  }

  var passwordInput: some View {
    formItemBuilder(
      hint: "Password",
      input: $loginViewModel.dto.password,
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
      loginViewModel.login()
    }
    .disabled(isLoginButtonDisabled)
    .opacity(loginButtonOpacity)
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
    .tint(.primary)
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

private typealias Response = ResponseDto<LoginResponseDto>

#Preview {
  LoginPage()
}
