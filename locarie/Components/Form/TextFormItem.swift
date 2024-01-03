//
//  TextFormItem.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct TextFormItem: View {
  let title: String
  let hint: String
  let input: Binding<String>
  let showIcon: Bool

  @FocusState private var isFocused: Bool

  init(
    title: String = "",
    hint: String,
    input: Binding<String>,
    showIcon: Bool = false
  ) {
    self.title = title
    self.hint = hint
    self.input = input
    self.showIcon = showIcon
  }

  var body: some View {
    VStack(alignment: .leading) {
      if !title.isEmpty {
        Text(title).padding(.leading)
      }
      inputFormItemBuilder(
        hint: hint,
        input: input,
        isFocused: $isFocused,
        isSecure: false,
        showIcon: showIcon
      )
    }
  }
}

#Preview {
  TextFormItem(
    title: "First name",
    hint: "First name",
    input: .constant("")
  )
}
