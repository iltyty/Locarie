//
//  LinkSettingsItem.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct LinkSettingsItem: View {
  let text: String
  let highlighted: Bool

  init(text: String, highlighted: Bool = false) {
    self.text = text
    self.highlighted = highlighted
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(text)
          .foregroundStyle(highlighted ? .blue : .primary)
        Spacer()
        Image(systemName: "chevron.right")
      }
      Divider()
    }
    .padding(.horizontal)
  }
}

#Preview {
  LinkSettingsItem(text: "Last name")
}
