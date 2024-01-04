//
//  SettingsPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct SettingsPage: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Constants.vSpacing) {
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
      EmptyView()
    } label: {
      LinkSettingsItem(text: "My account")
    }
  }

  var changePassword: some View {
    NavigationLink {
      EmptyView()
    } label: {
      LinkSettingsItem(text: "Change password")
    }
  }

  var notifications: some View {
    NavigationLink {
      EmptyView()
    } label: {
      LinkSettingsItem(text: "Notifications")
    }
  }

  var socialAccounts: some View {
    NavigationLink {
      EmptyView()
    } label: {
      LinkSettingsItem(text: "Social accounts")
    }
  }

  var locarieForBusinessSectionTitle: some View {
    SettingsSectionTitle(text: "Locarie for business")
  }

  var signUpForBusiness: some View {
    NavigationLink {
      EmptyView()
    } label: {
      LinkSettingsItem(text: "Sign up for business account")
    }
  }

  var supportSectionTitle: some View {
    SettingsSectionTitle(text: "Support")
  }

  var feedback: some View {
    NavigationLink {
      EmptyView()
    } label: {
      LinkSettingsItem(text: "Feedback")
    }
  }

  var legalSectionTitle: some View {
    SettingsSectionTitle(text: "Legal")
  }

  var privacyPolicy: some View {
    NavigationLink {
      EmptyView()
    } label: {
      LinkSettingsItem(text: "Privacy policy")
    }
  }

  var termsOfService: some View {
    NavigationLink {
      EmptyView()
    } label: {
      LinkSettingsItem(text: "Terms of services")
    }
  }

  var termsOfUse: some View {
    NavigationLink {
      EmptyView()
    } label: {
      LinkSettingsItem(text: "Terms of use")
    }
  }

  var logout: some View {
    Button("Log out") {
      print("log out button tapped")
    }
    .padding(.leading)
  }
}

private enum Constants {
  static let vSpacing = 20.0
}

#Preview {
  SettingsPage()
}
