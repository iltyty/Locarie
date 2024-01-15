//
//  LoginOrRegisterPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct LoginOrRegisterPage: View {
  var body: some View {
    VStack(spacing: Constants.spacing) {
      Spacer()
      locarieIcon
      Spacer()
      loginButton
      signupButton
      orText
      signupBusinessButton
      Spacer()
      BottomTabView()
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
    NavigationLink(value: Router.Destination.login) {
      primaryColorFormItemBuilder(text: "Log in")
    }
  }

  var signupButton: some View {
    NavigationLink(value: Router.Destination.regularRegister) {
      primaryColorFormItemBuilder(text: "Sign up for regular")
    }
  }

  var signupBusinessButton: some View {
    NavigationLink(value: Router.Destination.businessRegister) {
      backgroundColorFormItemBuilder(text: "Sign up for business")
        .tint(.primary)
    }
  }

  var orText: some View {
    Text("or").foregroundStyle(.secondary)
  }
}

private enum Constants {
  static let spacing = 15.0
  static let locarieIconSize = 64.0
}

#Preview {
  LoginOrRegisterPage()
}
