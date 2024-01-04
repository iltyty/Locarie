//
//  NotificationsPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct NotificationsPage: View {
  var body: some View {
    VStack(spacing: SettingsConstants.vSpacing) {
      navigationTitle
      newsAndUpdates
      messaging
      Spacer()
    }
  }
}

private extension NotificationsPage {
  var navigationTitle: some View {
    NavigationTitle("Notifications", divider: true)
  }

  var newsAndUpdates: some View {
    ToggleSettingsItem(title: "News and updates")
  }

  var messaging: some View {
    ToggleSettingsItem(title: "Messaging")
  }
}

#Preview {
  NotificationsPage()
}
