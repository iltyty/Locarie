//
//  ButtonFormItem.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct ButtonFormItem: View {
  let title: String
  let color: Color

  var body: some View {
    Text(title)
      .fontWeight(.semibold)
      .foregroundStyle(color)
      .frame(width: Constants.width, height: FormItemCommonConstants.height)
      .background(background)
      .tint(color)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .stroke(color)
  }
}

private enum Constants {
  static let width: CGFloat = 292
}

#Preview {
  VStack {
    ButtonFormItem(title: "Sign up", color: .locariePrimary)
    ButtonFormItem(
      title: "Sign up for a business account",
      color: Color(hex: 0x326AFB)
    )
  }
}
