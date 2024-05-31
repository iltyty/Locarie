//
//  StrokeButtonFormItem.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct StrokeButtonFormItem: View {
  let title: String
  var isFullWidth = true
  var isFixedWidth = false
  var color: Color = .locariePrimary

  var body: some View {
    Group {
      if isFixedWidth {
        content.frame(width: Constants.width)
      } else if isFullWidth {
        content.frame(maxWidth: .infinity)
      } else {
        content
      }
    }
    .padding(.vertical, FormItemCommonConstants.vPadding)
    .padding(.horizontal, FormItemCommonConstants.hPadding)
    .background(background)
  }

  private var content: some View {
    Text(title)
      .padding(.horizontal, textHPadding)
      .fontWeight(.semibold)
      .foregroundStyle(color)
      .tint(color)
  }

  private var textHPadding: CGFloat {
    if isFullWidth || isFixedWidth {
      0
    } else {
      Constants.textHPadding
    }
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .stroke(color)
  }
}

private enum Constants {
  static let width: CGFloat = 292
  static let textHPadding: CGFloat = 48
}

#Preview {
  VStack {
    StrokeButtonFormItem(title: "Sign up", isFullWidth: false)
    StrokeButtonFormItem(
      title: "Sign up for a business account",
      color: Color(hex: 0x326AFB)
    )
    StrokeButtonFormItem(
      title: "Sign up for a business account",
      isFixedWidth: true,
      color: Color(hex: 0x326AFB)
    )
  }
}
