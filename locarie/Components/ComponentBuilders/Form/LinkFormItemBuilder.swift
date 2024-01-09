//
//  LinkFormItemBuilder.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func linkFormItemBuilder(hint: String, text: Binding<String>) -> some View {
  HStack {
    TextField(hint, text: text).disabled(true)
    Spacer()
    Image(systemName: "chevron.right").foregroundStyle(.secondary)
  }
  .padding(.horizontal)
  .background(formItemBackground(.background))
  .padding(.horizontal)
  .frame(height: ComponentBuilderConstants.formItemHeight)
}
