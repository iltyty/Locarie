//
//  LinkFormItem.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct LinkFormItem: View {
  let title: String
  let hint: String
  let text: Binding<String>

  init(title: String = "", hint: String, text: Binding<String>) {
    self.title = title
    self.hint = hint
    self.text = text
  }

  var body: some View {
    VStack(alignment: .leading) {
      if !title.isEmpty {
        Text(title).padding(.leading)
      }
      linkFormItemBuilder(hint: hint, text: text)
    }
  }
}
