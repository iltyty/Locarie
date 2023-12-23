//
//  LoginOrRegisterPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct LoginOrRegisterPage: View {
  var body: some View {
    NavigationView {
      VStack(spacing: Constants.spacing) {
        Spacer()
        locarieIcon
        Spacer()
        loginButton
        signupButton
        orText
//        signupForBusinessText
        signupBusinessButton
        Spacer()
      }
    }
  }

  var locarieIcon: some View {
    Image("LocarieIcon")
      .resizable()
      .frame(
        width: Constants.locarieIconSize,
        height: Constants.locarieIconSize
      )
  }

  var loginButton: some View {
    primaryButtonBuilder(text: "Log in") {
      print("log in button tapped")
    }
  }

  var signupButton: some View {
    primaryButtonBuilder(text: "Sign up for regular") {
      print("sign up button tapped")
    }
  }

  var signupBusinessButton: some View {
    primaryButtonBuilder(text: "Sign up for business") {
      print("sign up business tapped")
    }
  }

  var orText: some View {
    Text("or").foregroundStyle(.secondary)
  }

  var signupForBusinessText: some View {
    NavigationLink {
      EmptyView()
    } label: {
      Text("Sign up for a business account")
    }
  }
}

private enum Constants {
  static let spacing = 15.0
  static let locarieIconSize = 64.0
}

#Preview {
  LoginOrRegisterPage()
}
