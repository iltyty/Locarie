//
//  TextEditFormItemWithInlineTitle.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct TextEditFormItemWithInlineTitle: View {
  let title: String
  let hint: String
  var note = ""

  @Binding var text: String

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text(title).frame(width: Constants.titleWidth, alignment: .leading)
        TextField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
          .textInputAutocapitalization(.never)
          .foregroundStyle(LocarieColor.greyDark)
        Spacer()
        Image("Pencil.Grey")
          .resizable()
          .scaledToFit()
          .frame(size: Constants.iconSize)
      }
      .padding(.horizontal, FormItemCommonConstants.hPadding)
      .frame(height: FormItemCommonConstants.height)
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

private enum Constants {
  static let titleWidth: CGFloat = 140
  static let iconSize: CGFloat = 16
}

#Preview {
  VStack {
    TextEditFormItemWithInlineTitle(
      title: "Business name",
      hint: "Business name",
      text: .constant("")
    )
    TextEditFormItemWithInlineTitle(
      title: "Email",
      hint: "Email",
      note: "Only letters, numbers, and full stops are allowed.",
      text: .constant("email@example.com")
    )
  }
}
