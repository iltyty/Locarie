//
//  LinkFormItemWithInlineTitle.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct LinkFormItemWithInlineTitle: View {
  let title: String
  let hint: String
  let isBindingText: Bool

  @Binding var text: String
  @Binding var textArray: [String]

  init(
    title: String,
    hint: String,
    text: Binding<String>
  ) {
    self.title = title
    self.hint = hint
    isBindingText = true
    _text = text
    _textArray = .constant([])
  }

  init(
    title: String,
    hint: String,
    textArray: Binding<[String]>
  ) {
    self.title = title
    self.hint = hint
    isBindingText = false
    _text = .constant("")
    _textArray = textArray
  }

  var body: some View {
    HStack {
      titleView
      textView
      Spacer()
      iconView
    }
    .padding(.vertical, FormItemCommonConstants.vPadding)
    .padding(.horizontal, FormItemCommonConstants.hPadding)
    .frame(maxWidth: .infinity)
    .background(background)
  }

  private var isShowingHint: Bool {
    if isBindingText {
      text.isEmpty
    } else {
      textArray.joined(separator: ", ").isEmpty
    }
  }

  private var textContent: String {
    if isBindingText {
      isShowingHint ? hint : text
    } else {
      isShowingHint ? hint : textArray.joined(separator: ", ")
    }
  }

  private var titleView: some View {
    Text(title).frame(width: Constants.titleWidth, alignment: .leading)
  }

  private var textView: some View {
    Text(textContent)
      .lineLimit(1)
      .foregroundStyle(LocarieColor.greyDark)
  }

  private var iconView: some View {
    Image(systemName: "chevron.right")
      .resizable()
      .scaledToFit()
      .foregroundStyle(.secondary)
      .frame(width: Constants.iconSize, height: Constants.iconSize)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .stroke(FormItemCommonConstants.strokeColor)
  }
}

private enum Constants {
  static let titleWidth: CGFloat = 140
  static let iconSize: CGFloat = 16
}

#Preview {
  VStack {
    LinkFormItemWithInlineTitle(
      title: "Business name",
      hint: "Business name",
      text: .constant("")
    )
    LinkFormItemWithInlineTitle(
      title: "Email",
      hint: "Email",
      text: .constant("email@example.com")
    )
  }
}
