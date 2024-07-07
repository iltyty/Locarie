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
    VStack(spacing: 0) {
      Toggle(title, isOn: $isOn).tint(LocarieColor.blue)
      if divider {
        Divider().foregroundStyle(LocarieColor.greyMedium)
      }
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 16)
    .background(.white)
  }
}

#Preview {
  ToggleSettingsItem(title: "News and updates")
}
