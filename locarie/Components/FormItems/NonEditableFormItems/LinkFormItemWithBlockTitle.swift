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
      titleView
      contentView
    }
  }

  private var titleView: some View {
    Text(title)
      .padding(.leading)
      .fontWeight(.semibold)
  }

  @ViewBuilder
  private var contentView: some View {
    HStack {
      textView
      Spacer()
      iconView
    }
    .background(background)
  }

  private var textView: some View {
    Text(textContent)
      .foregroundStyle(isShowingHint ? .secondary : .primary)
      .padding(.leading)
      .frame(height: FormItemCommonConstants.height)
  }

  private var iconView: some View {
    Image(systemName: "chevron.right")
      .font(.system(size: Constants.iconSize))
      .padding(.trailing)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .stroke(FormItemCommonConstants.strokeColor)
  }
}

private enum Constants {
  static let iconSize: CGFloat = 16
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
