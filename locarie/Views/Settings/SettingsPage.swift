//
//  SettingsPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct SettingsPage: View {
  @State var path = [Route]()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: SettingsConstants.vSpacing) {
        navigationTitle
        accountSectionTitle
        myAccount
        changePassword
        notifications
        socialAccounts
        locarieForBusinessSectionTitle
        signUpForBusiness
        supportSectionTitle
        feedback
        legalSectionTitle
        privacyPolicy
        termsOfService
        termsOfUse
        logout
      }
    }
  }
}

private extension SettingsPage {
  var navigationTitle: some View {
    NavigationTitle("Account")
  }

  var accountSectionTitle: some View {
    SettingsSectionTitle(text: "Account")
  }

  var myAccount: some View {
    NavigationLink {
      MyAccountPage()
    } label: {
      LinkSettingsItem(text: "My account")
    }
    .buttonStyle(.plain)
  }

  var changePassword: some View {
    NavigationLink {
      ChangePasswordPage()
    } label: {
      LinkSettingsItem(text: "Change password")
    }
    .buttonStyle(.plain)
  }

  var notifications: some View {
    NavigationLink {
      NotificationsPage()
    } label: {
      LinkSettingsItem(text: "Notifications")
    }
    .buttonStyle(.plain)
  }

  var socialAccounts: some View {
    NavigationLink {
      SocialAccountsPage()
    } label: {
      LinkSettingsItem(text: "Social accounts")
    }
    .buttonStyle(.plain)
  }

  var locarieForBusinessSectionTitle: some View {
    SettingsSectionTitle(text: "Locarie for business")
  }

  var signUpForBusiness: some View {
    NavigationLink(value: Route.businessRegister) {
      LinkSettingsItem(text: "Sign up for business account", highlighted: true)
    }
    .buttonStyle(.plain)
  }

  var supportSectionTitle: some View {
    SettingsSectionTitle(text: "Support")
  }

  var feedback: some View {
    NavigationLink {
      FeedbackPage()
    } label: {
      LinkSettingsItem(text: "Feedback")
    }
    .buttonStyle(.plain)
  }

  var legalSectionTitle: some View {
    SettingsSectionTitle(text: "Legal")
  }

  var privacyPolicy: some View {
    NavigationLink {
      PrivacyPolicyPage()
    } label: {
      LinkSettingsItem(text: "Privacy policy")
    }
    .buttonStyle(.plain)
  }

  var termsOfService: some View {
    NavigationLink {
      TermsOfServicePage()
    } label: {
      LinkSettingsItem(text: "Terms of services")
    }
    .buttonStyle(.plain)
  }

  var termsOfUse: some View {
    NavigationLink {
      TermsOfUsePage()
    } label: {
      LinkSettingsItem(text: "Terms of use")
    }
    .buttonStyle(.plain)
  }

  var logout: some View {
    Button("Log out") {
      print("log out button tapped")
    }
    .padding(.leading)
  }
}

#Preview {
  SettingsPage()
}
