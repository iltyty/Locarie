//
//  LinkFormItemWithBlockTitle.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct LinkFormItemWithBlockTitle: View {
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

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .padding(.leading)
        .fontWeight(.semibold)
      HStack {
        textView
        Spacer()
        iconView
      }
      .contentShape(Rectangle())
      .background {
        RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
          .strokeBorder(FormItemCommonConstants.strokeColor, style: .init(lineWidth: 1.5))
      }
    }
  }

  private var textView: some View {
    Text(textContent)
      .foregroundStyle(isShowingHint ? .secondary : .primary)
      .frame(height: FormItemCommonConstants.height)
      .padding(.horizontal, FormItemCommonConstants.hPadding)
  }

  private var iconView: some View {
    Image("Chevron.Right.Grey")
      .resizable()
      .scaledToFit()
      .frame(width: 16, height: 16)
      .padding(.trailing)
      .contentShape(Rectangle())
  }
}

#Preview {
  VStack {
    LinkFormItemWithBlockTitle(
      title: "Business address",
      hint: "Address",
      text: .constant("")
    )
    LinkFormItemWithBlockTitle(
      title: "Business categories",
      hint: "Categories",
      textArray: .constant([])
    )
    LinkFormItemWithBlockTitle(
      title: "Business categories",
      hint: "Categories",
      textArray: .constant(["Food & Drinks", "Shop", "Lifestyle"])
    )
  }
}
