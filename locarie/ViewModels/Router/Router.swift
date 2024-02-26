//
//  Router.swift
//  locarie
//
//  Created by qiuty on 07/01/2024.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
  static let shared = Router()
  @Published var path = NavigationPath()

  private init() {}

  func navigation(to destination: Destination) {
    path.append(destination)
  }

  func navigateBack() {
    path.removeLast()
  }

  func navigateToRoot() {
    path.removeLast(path.count)
  }
}

extension Router {
  enum Destination: Hashable {
    case favorite

    case loginOrRegister, login, regularRegister, businessRegister,
         resetPassword

    case settings, myAccount, changePassword, newPassword,
         feedback, privacyPolicy, termsOfUse, termsOfService

    case userProfile, regularUserProfile, businessUserProfile, userProfileEdit
  }
}

extension Router {
  func getDestinationPage(with destination: Destination) -> some View {
    Group {
      switch destination {
      case .favorite:
        FavoritePage()
      case .loginOrRegister:
        LoginOrRegisterPage()
      case .login:
        LoginPage()
      case .regularRegister:
        RegularRegisterPage()
      case .businessRegister:
        BusinessRegisterPage()
      case .resetPassword:
        ForgotPasswordPage()

      case .settings:
        SettingsPage()
      case .myAccount:
        MyAccountPage()
      case .changePassword:
        ChangePasswordPage()
      case .newPassword:
        NewPasswordPage()
      case .feedback:
        FeedbackPage()
      case .privacyPolicy:
        PrivacyPolicyPage()
      case .termsOfUse:
        TermsOfUsePage()
      case .termsOfService:
        TermsOfServicePage()

      case .userProfile:
        UserProfilePage()
      case .regularUserProfile:
        RegularUserProfilePage()
      case .businessUserProfile:
        BusinessUserProfilePage()
      case .userProfileEdit:
        UserProfileEditPage()
      }
    }
  }
}
