//
//  MyAccountPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct MyAccountPage: View {
  var body: some View {
    VStack(alignment: .leading, spacing: SettingsConstants.vSpacing) {
      navigationTitle
      accountType
      businessType
      businessName
      email
      username
      firstName
      lastName
      version
      editProfile
      deleteAccount
      Spacer()
    }
  }
}

private extension MyAccountPage {
  var navigationTitle: some View {
    NavigationTitle("My account", divider: true)
  }

  var accountType: some View {
    TextSettingsItem(title: "Account type", value: "Visitor")
  }

  var businessType: some View {
    TextSettingsItem(title: "Business type", value: "Cafe")
  }

  var businessName: some View {
    TextSettingsItem(title: "Business name", value: "Shreeji Newsagent")
  }

  var email: some View {
    TextSettingsItem(title: "Email", value: "www.something@email.com")
  }

  var username: some View {
    TextSettingsItem(title: "@username", value: "username")
  }

  var firstName: some View {
    TextSettingsItem(title: "First name", value: "Name")
  }

  var lastName: some View {
    TextSettingsItem(title: "Last name", value: "Name")
  }

  var version: some View {
    TextSettingsItem(title: "Version", value: "V0.0.1")
  }

  var editProfile: some View {
    NavigationLink("Edit profile") {
      BusinessUserProfileEditPage()
    }
    .padding()
  }

  var deleteAccount: some View {
    Button("Delete account") {
      print("delete account button tapped")
    }
    .foregroundStyle(.red)
    .padding(.horizontal)
  }
}

#Preview {
  MyAccountPage()
}
