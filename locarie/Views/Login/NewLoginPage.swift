//
//  NewLoginPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct NewLoginPage: View {
  @StateObject var authViewModel = AuthViewModel()

  var body: some View {
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
      input: $authViewModel.loginRequestDto.email,
      isSecure: false
    )
  }

  var passwordInput: some View {
    formItemBuilder(
      hint: "Password",
      input: $authViewModel.loginRequestDto.password,
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
      print("log in button tapped")
    }
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

private enum Constants {
  static let locarieIconSize = 64.0
  static let googleIconSize = 32.0
  static let formItemSpacing = 15.0
}

#Preview {
  NewLoginPage()
}
