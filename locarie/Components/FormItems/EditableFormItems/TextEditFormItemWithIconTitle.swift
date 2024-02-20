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

  @Binding var text: String

  var body: some View {
    HStack {
      iconView
      textEditView
      Spacer()
    }
    .fontWeight(.semibold)
    .padding(.horizontal)
    .frame(maxWidth: .infinity)
    .frame(height: FormItemCommonConstants.height)
    .background(background)
  }

  private var iconView: some View {
    Image(systemName: iconSystemName)
      .resizable()
      .scaledToFit()
      .frame(width: Constants.iconSize, height: Constants.iconSize)
  }

  private var textEditView: some View {
    TextField(hint, text: $text)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .stroke(.secondary)
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
