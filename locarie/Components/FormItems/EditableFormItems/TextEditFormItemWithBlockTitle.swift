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
      titleView
      textEditView
    }
    .fontWeight(.semibold)
  }

  private var titleView: some View {
    Text(title).padding(.leading)
  }

  @ViewBuilder
  private var textEditView: some View {
    Group {
      if isSecure {
        SecureField(hint, text: $text)
      } else {
        TextField(hint, text: $text)
      }
    }
    .padding(.horizontal)
    .frame(height: FormItemCommonConstants.height)
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
