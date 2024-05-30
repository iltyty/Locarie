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
      navigationBar.background(.white)
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
          termsOfUse
          logout.padding(.top, 48)
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
  var navigationBar: some View {
    NavigationBar("Account", divider: true)
  }

  var accountSectionTitle: some View {
    SettingsSectionTitle(text: "Account")
  }

  var myAccount: some View {
    NavigationLink(value: Router.Destination.myAccount) {
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
      LinkSettingsItem(text: "Notifications", divider: false)
    }
    .buttonStyle(.plain)
  }

  var locarieForBusinessSectionTitle: some View {
    SettingsSectionTitle(text: "Locarie for business")
  }

  var signUpForBusiness: some View {
    NavigationLink(value: Router.Destination.businessDescription) {
      LinkSettingsItem(text: "Sign up for a business account", color: LocarieColor.blue, divider: false)
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
      LinkSettingsItem(text: "Feedback", color: LocarieColor.primary, divider: false)
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
      LinkSettingsItem(text: "Terms of use", divider: false)
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
