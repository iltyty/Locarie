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
    VStack(alignment: .leading, spacing: 16) {
      Text(title).padding(.leading, FormItemCommonConstants.hPadding)
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
    .padding(.horizontal, FormItemCommonConstants.hPadding)
    .frame(height: FormItemCommonConstants.height)
    .background(background)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .strokeBorder(FormItemCommonConstants.strokeColor, style: .init(lineWidth: 1.5))
      .padding(0.75)
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
