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
    ZStack(alignment: .bottom) {
      HStack {
        Text(text)
          .foregroundStyle(color)
        Spacer()
        Image(systemName: "chevron.right")
      }
      .frame(height: SettingsConstants.rowHeight)
      if divider {
        Divider()
      }
    }
    .padding(.horizontal)
    .background(.white)
  }
}

#Preview {
  LinkSettingsItem(text: "Last name")
}
