//
//  SocialAccountsPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct SocialAccountsPage: View {
  var body: some View {
    VStack(spacing: SettingsConstants.vSpacing) {
      navigationTitle
      google
      Spacer()
    }
  }
}

private extension SocialAccountsPage {
  var navigationTitle: some View {
    NavigationTitle("Social accounts", divider: true)
  }

  var google: some View {
    LabelSettingsItem(label: googleLabel, value: "Disconnected")
  }

  var googleLabel: some View {
    Label("Google", image: "GoogleLogo")
  }
}

#Preview {
  SocialAccountsPage()
}
