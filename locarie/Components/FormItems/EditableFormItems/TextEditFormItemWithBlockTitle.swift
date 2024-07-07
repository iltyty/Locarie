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
  var note = ""
  var isSecure = false

  @Binding var text: String

  @State private var showingPassword = false

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(title)
        .padding(.bottom, 16)
        .padding(.leading, FormItemCommonConstants.hPadding)
      textEditView
      FormItemNoteView(note)
    }
  }

  @ViewBuilder
  private var textEditView: some View {
    HStack(spacing: 0) {
      if isSecure, !showingPassword {
        SecureField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
      } else {
        TextField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
      }
      Spacer()
      if isSecure, !text.isEmpty {
        FormItemPasswordSwitchView(showing: $showingPassword)
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
