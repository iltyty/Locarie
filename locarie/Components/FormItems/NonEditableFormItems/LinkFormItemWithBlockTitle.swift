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

  @Binding var text: String

  var body: some View {
    VStack(alignment: .leading) {
      titleView
      textEditView
    }
  }

  private var titleView: some View {
    Text(title)
      .padding(.leading)
      .fontWeight(.semibold)
  }

  @ViewBuilder
  private var textEditView: some View {
    HStack {
      textView
      Spacer()
      iconView
    }
    .background(background)
  }

  private var textView: some View {
    TextField(hint, text: $text)
      .disabled(true)
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
  LinkFormItemWithBlockTitle(
    title: "Business address",
    hint: "Address",
    text: .constant("")
  )
}
