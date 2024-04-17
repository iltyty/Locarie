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
      navigationBar
      newsAndUpdates
      messaging
      Spacer()
    }
  }
}

private extension NotificationsPage {
  var navigationBar: some View {
    NavigationBar("Notifications", divider: true)
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
