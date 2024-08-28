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

  func navigate(to destination: any Hashable) {
    path.append(destination)
  }

  func navigateBack() {
    path.removeLast()
  }

  func navigateToRoot() {
    path.removeLast(path.count)
  }

  func navigateToMinePage() {
    path.removeLast(path.count)
    BottomTabViewRouter.shared.currentPage = .profile
  }
}

extension Router {
  enum Destination: Hashable {
    case favorite

    case loginOrRegister, login, regularRegister, businessDescription,
         businessRegister, forgotPassword, notifications, distanceUnits

    case settings, myAccount, changePassword, newPassword,
         feedback, privacyPolicy, termsOfService, communityGuidelines

    case userProfile, regularUserProfile, businessUserProfile, businessImagesEdit,
         userProfileEdit
  }

  enum StringDestination: Hashable {
    case codeValidation(String), resetPassword(String)
  }

  enum Int64Destination: Hashable {
    case businessHome(Int64, Bool)
  }
}

extension Router {
  @ViewBuilder
  func getDestinationPage(with destination: Destination) -> some View {
    switch destination {
    case .favorite:
      FavoritePage()
    case .loginOrRegister:
      LoginOrRegisterPage()
    case .login:
      LoginPage()
    case .regularRegister:
      RegularRegisterPage()
    case .businessDescription:
      BusinessDescriptionPage()
    case .businessRegister:
      BusinessRegisterPage()
    case .forgotPassword:
      ForgotPasswordPage()
    case .notifications:
      NotificationsPage()
    case .distanceUnits:
      DistanceUnitsPage()

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
    case .termsOfService:
      TermsOfServicePage()
    case .communityGuidelines:
      CommunityGuidelinesPage()

    case .userProfile:
      UserProfilePage()
    case .regularUserProfile:
      RegularUserProfilePage()
    case .businessUserProfile:
      BusinessUserProfilePage()
    case .businessImagesEdit:
      BusinessImagesEditPage()
    case .userProfileEdit:
      UserProfileEditPage()
    }
  }

  @ViewBuilder
  func getStringDestinationPage(with destination: StringDestination) -> some View {
    switch destination {
    case let .codeValidation(email):
      CodeValidationPage(email: email)
    case let .resetPassword(email):
      ResetPasswordPage(email: email)
    }
  }

  @ViewBuilder
  func getInt64DestinationPage(with destination: Int64Destination) -> some View {
    switch destination {
    case let .businessHome(uid, fullscreen):
      BusinessHomePage(uid: uid, fullscreen: fullscreen)
    }
  }
}
