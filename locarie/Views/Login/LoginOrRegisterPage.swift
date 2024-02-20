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
    .ignoresSafeArea(edges: .bottom)
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
      strokeFormItemBuilder(text: "Sign up", color: Color.locariePrimary)
    }
  }

  var signupBusinessButton: some View {
    NavigationLink(value: Router.Destination.businessRegister) {
      strokeFormItemBuilder(
        text: "Sign up for a business account",
        color: Constants.businessButtonColor
      )
    }
  }

  var orText: some View {
    Text("or")
      .fontWeight(.semibold)
      .foregroundStyle(.secondary)
  }
}

private enum Constants {
  static let spacing = 15.0
  static let locarieIconSize = 72.0
  static let businessButtonColor = Color(hex: 0x326AFB)
}

#Preview {
  LoginOrRegisterPage()
}
