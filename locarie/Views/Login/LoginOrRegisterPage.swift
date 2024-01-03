//
//  LoginOrRegisterPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct LoginOrRegisterPage: View {
  @State var path: [Route] = []

  var body: some View {
    NavigationStack(path: $path) {
      VStack(spacing: Constants.spacing) {
        Spacer()
        locarieIcon
        Spacer()
        loginButton
        signupButton
        orText
        signupBusinessButton
        Spacer()
      }
      .navigationDestination(for: Route.self) { route in
        getRoutePage(route, path: $path)
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
    NavigationLink(value: Route.login) {
      primaryColorFormItemBuilder(text: "Log in")
    }
  }

  var signupButton: some View {
    NavigationLink(value: Route.regularRegister) {
      primaryColorFormItemBuilder(text: "Sign up for regular")
    }
  }

  var signupBusinessButton: some View {
    NavigationLink(value: Route.businessRegister) {
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
    .environmentObject(LocalCacheViewModel())
}
