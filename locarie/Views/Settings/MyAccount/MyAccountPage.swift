//
//  MyAccountPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct MyAccountPage: View {
  @State private var presentingAlert = false

  @ObservedObject private var router = Router.shared
  @StateObject private var deleteVM = UserDeleteViewModel()
  @StateObject private var profileVM = ProfileGetViewModel()
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack {
      navigationBar
      VStack(alignment: .leading, spacing: SettingsConstants.vSpacing) {
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
      .padding([.top, .horizontal])
    }
    .alert("Confirm", isPresented: $presentingAlert) {
      Button("Delete", role: .destructive) {
        deleteVM.delete(id: cacheVM.getUserId())
      }
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("This will delete all your data")
    }
    .onAppear {
      profileVM.getProfile(userId: cacheVM.getUserId())
    }
    .onReceive(deleteVM.$state) { state in
      if case .finished = state {
        cacheVM.clean()
        router.navigateToRoot()
      }
    }
  }
}

private extension MyAccountPage {
  var navigationBar: some View {
    NavigationBar("My account", divider: true)
  }

  var accountType: some View {
    let accountType = profileVM.dto
      .type == .regular ? "Visitor" : "Business"
    return TextSettingsItem(title: "Account type", value: accountType)
  }

  var businessName: some View {
    Group {
      if profileVM.dto.type == .regular {
        EmptyView()
      } else {
        let name = profileVM.dto.businessName
        TextSettingsItem(title: "Business name", value: name)
      }
    }
  }

  var businessCategories: some View {
    Group {
      if profileVM.dto.type == .regular {
        EmptyView()
      } else {
        let categories = profileVM.dto.categories
        TextSettingsItem(
          title: "Business categories",
          value: categories.joined(separator: ", ")
        )
      }
    }
  }

  var email: some View {
    let email = profileVM.dto.email
    return TextSettingsItem(title: "Email", value: email)
  }

  var username: some View {
    let username = profileVM.dto.username
    return TextSettingsItem(title: "@Username", value: username)
  }

  var firstName: some View {
    let firstName = profileVM.dto.firstName
    return TextSettingsItem(title: "First name", value: firstName)
  }

  var lastName: some View {
    let lastName = profileVM.dto.lastName
    return TextSettingsItem(title: "Last name", value: lastName)
  }

  var version: some View {
    TextSettingsItem(title: "Version", value: "V0.0.1")
  }

  var editProfile: some View {
    NavigationLink("Edit profile") {
      UserProfileEditPage()
    }
    .padding(.vertical)
  }

  var deleteAccount: some View {
    Button("Delete account") {
      presentingAlert = true
    }
    .foregroundStyle(.red)
  }
}

#Preview {
  MyAccountPage()
}
