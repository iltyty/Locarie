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
  var divider: Bool = true

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text(title)
        Spacer()
        Text(value).foregroundStyle(LocarieColor.greyDark)
      }
      .lineLimit(1)
      .padding(.vertical, 20)
      if divider {
        Divider().foregroundStyle(LocarieColor.greyMedium)
      }
    }
    .padding(.horizontal, 16)
    .background(.white)
  }
}

#Preview {
  TextSettingsItem(title: "Account type", value: "Business")
}
