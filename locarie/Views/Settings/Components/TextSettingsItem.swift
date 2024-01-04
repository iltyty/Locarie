//
//  TextSettingsItem.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct TextSettingsItem: View {
  let title: String
  let value: String

  var body: some View {
    VStack {
      HStack {
        Text(title).fontWeight(.bold)
        Spacer()
        Text(value).foregroundStyle(.secondary)
      }
      Divider()
    }
    .padding(.horizontal)
  }
}

#Preview {
  TextSettingsItem(title: "Account type", value: "Business")
}
