//
//  MyAccountPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct MyAccountPage: View {
  @StateObject private var profileViewModel = ProfileGetViewModel()
  @ObservedObject private var cacheViewModel = LocalCacheViewModel.shared

  var body: some View {
    VStack(alignment: .leading, spacing: SettingsConstants.vSpacing) {
      navigationTitle
      accountType
      businessName
      businessCategories
      email
      username
      firstName
      lastName
      version
      editProfile
      deleteAccount
      Spacer()
    }
    .onAppear {
      profileViewModel.getProfile(userId: cacheViewModel.getUserId())
    }
  }
}

private extension MyAccountPage {
  var navigationTitle: some View {
    NavigationTitle("My account", divider: true)
  }

  var accountType: some View {
    let accountType = profileViewModel.dto
      .type == .regular ? "Visitor" : "Business"
    return TextSettingsItem(title: "Account type", value: accountType)
  }

  var businessName: some View {
    Group {
      if profileViewModel.dto.type == .regular {
        EmptyView()
      } else {
        let name = profileViewModel.dto.businessName
        TextSettingsItem(title: "Business name", value: name)
      }
    }
  }

  var businessCategories: some View {
    Group {
      if profileViewModel.dto.type == .regular {
        EmptyView()
      } else {
        let categories = profileViewModel.dto.categories
        TextSettingsItem(
          title: "Business categories",
          value: categories.joined(separator: ", ")
        )
      }
    }
  }

  var email: some View {
    let email = profileViewModel.dto.email
    return TextSettingsItem(title: "Email", value: email)
  }

  var username: some View {
    let username = profileViewModel.dto.username
    return TextSettingsItem(title: "@Username", value: username)
  }

  var firstName: some View {
    let firstName = profileViewModel.dto.firstName
    return TextSettingsItem(title: "First name", value: firstName)
  }

  var lastName: some View {
    let lastName = profileViewModel.dto.lastName
    return TextSettingsItem(title: "Last name", value: lastName)
  }

  var version: some View {
    TextSettingsItem(title: "Version", value: "V0.0.1")
  }

  var editProfile: some View {
    NavigationLink("Edit profile") {
      UserProfileEditPage()
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
