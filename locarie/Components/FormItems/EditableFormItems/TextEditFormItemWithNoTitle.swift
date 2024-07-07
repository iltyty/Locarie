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
  var note = ""

  @Binding var text: String

  @State private var showingPassword = false

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
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
      .frame(height: FormItemCommonConstants.height)
      .padding(.horizontal, FormItemCommonConstants.hPadding)
      .frame(maxWidth: .infinity)
      .background(background)
      FormItemNoteView(note)
    }
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .strokeBorder(FormItemCommonConstants.strokeColor, style: .init(lineWidth: 1.5))
  }
}

#Preview {
  VStack {
    TextEditFormItemWithNoTitle(
      hint: "Businesss name",
      text: .constant("name")
    )
    TextEditFormItemWithNoTitle(
      hint: "Password",
      isSecure: true,
      text: .constant("12345678")
    )
  }
}
