//
//  ToggleSettingsItem.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct ToggleSettingsItem: View {
  let title: String
  var divider = true

  @State var isOn = false

  var body: some View {
    ZStack(alignment: .bottom) {
      HStack {
        Toggle(title, isOn: $isOn).tint(.locariePrimary)
      }
      if divider {
        Divider()
      }
    }
    .padding(.horizontal)
    .frame(height: SettingsConstants.rowHeight)
  }
}

#Preview {
  ToggleSettingsItem(title: "News and updates")
}
