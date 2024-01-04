//
//  LinkSettingsItem.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct LinkSettingsItem: View {
  let text: String

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(text)
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
