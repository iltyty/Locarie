//
//  TextEditFormItemWithBlockTitle.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct TextEditFormItemWithBlockTitle: View {
  let title: String
  let hint: String
  var isSecure = false

  @Binding var text: String

  var body: some View {
    VStack(alignment: .leading) {
      Text(title).padding(.leading, 16)
      textEditView
    }
  }

  @ViewBuilder
  private var textEditView: some View {
    Group {
      if isSecure {
        SecureField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
      } else {
        TextField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
      }
    }
    .textInputAutocapitalization(.never)
    .padding(.vertical, FormItemCommonConstants.vPadding)
    .padding(.horizontal, FormItemCommonConstants.hPadding)
    .background(background)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .stroke(FormItemCommonConstants.strokeColor)
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 16) {
    TextEditFormItemWithBlockTitle(
      title: "Business name",
      hint: "Business name",
      text: .constant("")
    )
    TextEditFormItemWithBlockTitle(
      title: "Password",
      hint: "Password",
      isSecure: true,
      text: .constant("")
    )
    TextEditFormItemWithBlockTitle(
      title: "Username",
      hint: "username",
      text: .constant("name")
    )
  }
}
