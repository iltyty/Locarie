//
//  LinkSettingsItem.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct LinkSettingsItem: View {
  let text: String
  var color: Color = .primary
  var divider: Bool = true

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text(text)
          .foregroundStyle(color)
          .padding(.vertical, 20)
        Spacer()
        Image(systemName: "chevron.right")
          .foregroundStyle(LocarieColor.greyDark)
          .frame(width: 16, height: 16)
      }
      if divider {
        Divider().foregroundStyle(LocarieColor.greyMedium)
      }
    }
    .padding(.horizontal, 16)
    .background(.white)
  }
}

#Preview {
  LinkSettingsItem(text: "Last name")
}
