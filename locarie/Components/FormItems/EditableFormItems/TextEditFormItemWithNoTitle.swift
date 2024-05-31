//
//  TextEditFormItemWithNoTitle.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct TextEditFormItemWithNoTitle: View {
  let hint: String
  var isSecure = false

  @Binding var text: String

  var body: some View {
    HStack {
      if isSecure {
        SecureField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
      } else {
        TextField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
      }
    }
    .textInputAutocapitalization(.never)
    .padding(.vertical, FormItemCommonConstants.vPadding)
    .padding(.horizontal, FormItemCommonConstants.hPadding)
    .frame(maxWidth: .infinity)
    .background(background)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .stroke(FormItemCommonConstants.strokeColor)
  }
}

#Preview {
  TextEditFormItemWithNoTitle(
    hint: "Businesss name",
    text: .constant("name")
  )
}
