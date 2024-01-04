//
//  ToggleSettingsItem.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct ToggleSettingsItem: View {
  @State var isOn = false

  let title: String

  var body: some View {
    VStack {
      HStack {
        Toggle(title, isOn: $isOn).tint(.locariePrimary)
      }
      Divider()
    }
    .padding(.horizontal)
  }
}

#Preview {
  ToggleSettingsItem(title: "News and updates")
}
