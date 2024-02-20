//
//  TextEditFormItemWithNoTitle.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct TextEditFormItemWithNoTitle: View {
  let hint: String

  @Binding var text: String

  var body: some View {
    HStack {
      TextField(hint, text: $text)
    }
    .padding(.horizontal)
    .frame(height: FormItemCommonConstants.height)
    .frame(maxWidth: .infinity)
    .background(background)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .stroke(.secondary)
  }
}

#Preview {
  TextEditFormItemWithNoTitle(
    hint: "Businesss name",
    text: .constant("name")
  )
}
