//
//  SettingsPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct SettingsPage: View {
  @StateObject private var deleteVM = UserDeleteViewModel()
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Account", divider: true).background(.white)
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          accountSectionTitle.padding(.top, 24).padding(.bottom, 15)
          myAccount
          changePassword
          notifications
          locarieForBusinessSectionTitle.padding(.top, 24).padding(.bottom, 15)
          signUpForBusiness
          supportSectionTitle.padding(.top, 24).padding(.bottom, 15)
          feedback
          legalSectionTitle.padding(.top, 24).padding(.bottom, 15)
          privacyPolicy
          termsOfService
          communityGuidelines
          logout.padding(.top, 48).padding(.bottom, 100)
          Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
        .background(LocarieColor.greyLight)
      }
      .scrollIndicators(.hidden)
    }
    .background(LocarieColor.greyLight)
  }
}

private extension SettingsPage {
  var accountSectionTitle: some View {
    SettingsSectionTitle(text: "Account")
  }

  var myAccount: some View {
    NavigationLink(value: Router.Destination.myAccount) {
      LinkSettingsItem(text: "My Account")
    }
    .buttonStyle(.plain)
  }

  var changePassword: some View {
    NavigationLink(value: Router.Destination.changePassword) {
      LinkSettingsItem(text: "Change Password")
    }
    .buttonStyle(.plain)
  }

  var notifications: some View {
    NavigationLink(value: Router.Destination.notifications) {
      LinkSettingsItem(text: "Notifications", divider: false)
    }
    .buttonStyle(.plain)
  }

  var locarieForBusinessSectionTitle: some View {
    SettingsSectionTitle(text: "Locarie for business")
  }

  var signUpForBusiness: some View {
    NavigationLink(value: Router.Destination.businessDescription) {
      LinkSettingsItem(
        text: "Sign Up for a Business Account",
        color: LocarieColor.blue,
        divider: false
      )
    }
    .buttonStyle(.plain)
  }

  var supportSectionTitle: some View {
    SettingsSectionTitle(text: "Support")
  }

  var feedback: some View {
    NavigationLink(value: Router.Destination.feedback) {
      LinkSettingsItem(text: "Feedback", color: LocarieColor.primary, divider: false)
    }
    .buttonStyle(.plain)
  }

  var legalSectionTitle: some View {
    SettingsSectionTitle(text: "Legal")
  }

  var privacyPolicy: some View {
    NavigationLink(value: Router.Destination.privacyPolicy) {
      LinkSettingsItem(text: "Privacy Policy")
    }
    .buttonStyle(.plain)
  }

  var termsOfService: some View {
    NavigationLink(value: Router.Destination.termsOfService) {
      LinkSettingsItem(text: "Terms of Services")
    }
    .buttonStyle(.plain)
  }

  var communityGuidelines: some View {
    NavigationLink(value: Router.Destination.communityGuidelines) {
      LinkSettingsItem(text: "Community Guidelines", divider: false)
    }
    .buttonStyle(.plain)
  }

  var logout: some View {
    Button("Log out") {
      cacheVM.clean()
      dismiss()
    }
    .padding(.horizontal, 16)
    .foregroundStyle(LocarieColor.blue)
    .buttonStyle(.plain)
  }
}

#Preview {
  SettingsPage()
}
