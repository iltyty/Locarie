//
//  LoginOrRegisterPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct LoginOrRegisterPage: View {
  var body: some View {
    ZStack {
      VStack {
        LinearGradient(colors: [LocarieColor.primary, Color.white], startPoint: .top, endPoint: .bottom)
          .frame(height: 400)
          .ignoresSafeArea(edges: .top)
        Spacer()
      }
      VStack(spacing: Constants.spacing) {
        Spacer()
        locarieIcon
        Spacer()
        loginButton
        signupButton
        orText.padding(.vertical, 8)
        signupBusinessButton
        Spacer()
        BottomTabView()
      }
      .ignoresSafeArea(edges: .bottom)
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
      BackgroundButtonFormItem(title: "Log in", isFixedWidth: true)
    }
  }

  var signupButton: some View {
    NavigationLink(value: Router.Destination.regularRegister) {
      StrokeButtonFormItem(title: "Sign up", isFixedWidth: true)
    }
  }

  var signupBusinessButton: some View {
    NavigationLink(value: Router.Destination.businessDescription) {
      StrokeButtonFormItem(
        title: "Sign up for a business account",
        isFixedWidth: true,
        color: LocarieColor.blue
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
  static let spacing = 16.0
  static let locarieIconSize = 72.0
  static let businessButtonColor = Color(hex: 0x326AFB)
}

#Preview {
  LoginOrRegisterPage()
}
