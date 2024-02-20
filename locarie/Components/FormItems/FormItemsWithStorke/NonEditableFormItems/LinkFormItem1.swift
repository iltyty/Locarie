//
//  LinkFormItem1.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct LinkFormItem1: View {
  let title: String
  let hint: String

  @Binding var text: String

  var body: some View {
    HStack {
      titleView
      textEditView
      Spacer()
      iconView
    }
    .fontWeight(.semibold)
    .padding(.horizontal)
    .frame(maxWidth: .infinity)
    .frame(height: FormItemCommonConstants.height)
    .background(background)
  }

  private var titleView: some View {
    HStack {
      Text(title)
    }
    .frame(width: Constants.titleWidth, alignment: .leading)
  }

  private var textEditView: some View {
    TextField(hint, text: $text).disabled(true)
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
      .stroke(.secondary)
  }
}

private enum Constants {
  static let titleWidth: CGFloat = 140
  static let iconSize: CGFloat = 16
}

#Preview {
  VStack {
    LinkFormItem1(
      title: "Business name",
      hint: "Business name",
      text: .constant("")
    )
    LinkFormItem1(
      title: "Email",
      hint: "Email",
      text: .constant("email@example.com")
    )
  }
}
