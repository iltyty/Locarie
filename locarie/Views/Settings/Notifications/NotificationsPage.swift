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
      NavigationBar("Notifications", divider: true).background(.white)
      ToggleSettingsItem(title: "News and updates", divider: false)
      Spacer()
    }
    .background(LocarieColor.greyLight)
  }
}

#Preview {
  NotificationsPage()
}
