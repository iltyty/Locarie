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
        formTitle
      }
      formText
    }
  }

  private var formTitle: some View {
    Text(title).fontWeight(.bold).padding(.leading)
  }

  private var formText: some View {
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
}
