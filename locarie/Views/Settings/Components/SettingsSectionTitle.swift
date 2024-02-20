//
//  SettingsSectionTitle.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct SettingsSectionTitle: View {
  let text: String

  var body: some View {
    VStack(alignment: .leading) {
      Text(text).fontWeight(.semibold)
      Divider()
    }
    .padding(.horizontal)
  }
}

#Preview {
  SettingsSectionTitle(text: "Account")
}
