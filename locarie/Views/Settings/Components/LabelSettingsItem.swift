//
//  LabelSettingsItem.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct LabelSettingsItem<L: View>: View {
  let label: L
  let value: String

  var body: some View {
    VStack {
      HStack {
        label
        Spacer()
        Text(value)
      }
      LocarieDivider()
    }
    .padding(.horizontal)
  }
}
