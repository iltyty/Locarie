//
//  Route.swift
//  locarie
//
//  Created by qiuty on 30/12/2023.
//

import Foundation
import SwiftUI

enum Route: String, Hashable, Codable {
  case login
  case loginOrRegister
  case businessRegister
  case regularRegister
  case forgotPassword
}

func getRoutePage(_ route: Route, path: Binding<[Route]>) -> some View {
  Group {
    switch route {
    case .login:
      LoginPage(path: path)
    case .loginOrRegister:
      LoginOrRegisterPage()
    case .businessRegister:
      BusinessRegisterPage(path: path)
    case .regularRegister:
      RegularRegisterPage(path: path)
    case .forgotPassword:
      ResetPasswordPage()
    }
  }
}
