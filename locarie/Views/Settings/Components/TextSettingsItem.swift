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
    ZStack(alignment: .bottom) {
      HStack {
        Text(title).fontWeight(.semibold)
        Spacer()
        Text(value).foregroundStyle(.secondary)
      }
      .lineLimit(1)
      .frame(height: SettingsConstants.rowHeight, alignment: .center)
      if divider {
        Divider()
      }
    }
    .padding(.horizontal)
    .background(.white)
  }
}

#Preview {
  TextSettingsItem(title: "Account type", value: "Business")
}
