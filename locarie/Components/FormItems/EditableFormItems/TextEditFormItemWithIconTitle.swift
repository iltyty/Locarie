//
//  TextEditFormItemWithIconTitle.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct TextEditFormItemWithIconTitle: View {
  let iconSystemName: String
  let hint: String
  var note = ""

  @Binding var text: String

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        iconView
        textEditView
        Spacer()
      }
      .padding(.horizontal)
      .padding(.horizontal, FormItemCommonConstants.hPadding)
      .frame(maxWidth: .infinity)
      .frame(height: FormItemCommonConstants.height)
      .background(background)
      FormItemNoteView(note)
    }
  }

  private var iconView: some View {
    Image(systemName: iconSystemName)
      .resizable()
      .scaledToFit()
      .frame(size: Constants.iconSize)
  }

  private var textEditView: some View {
    TextField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
      .textInputAutocapitalization(.never)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .strokeBorder(FormItemCommonConstants.strokeColor, style: .init(lineWidth: 1.5))
  }
}

private enum Constants {
  static let iconSize: CGFloat = 16
}

#Preview {
  VStack {
    TextEditFormItemWithIconTitle(
      iconSystemName: "magnifyingglass",
      hint: "search",
      text: .constant("")
    )
    TextEditFormItemWithIconTitle(
      iconSystemName: "bookmark",
      hint: "book",
      text: .constant("")
    )
  }
}
