//
//  BackgroundButtonFormItem.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct BackgroundButtonFormItem: View {
  let title: String
  var isFullWidth = true
  var isFixedWidth = false
  let color: Color = .locariePrimary

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
    .padding(.horizontal, FormItemCommonConstants.hPadding)
    .frame(height: FormItemCommonConstants.height)
    .background(background)
  }

  private var content: some View {
    Text(title)
      .padding(.horizontal, Constants.textHPadding)
      .font(.custom(GlobalConstants.fontName, size: 18))
      .foregroundStyle(.white)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius).fill(color)
  }
}

private enum Constants {
  static let width: CGFloat = 292
  static let textHPadding: CGFloat = 48
}

#Preview {
  VStack {
    BackgroundButtonFormItem(title: "Log in")
    BackgroundButtonFormItem(title: "Log in", isFullWidth: false)
    BackgroundButtonFormItem(title: "Log in", isFixedWidth: true)
    BackgroundButtonFormItem(
      title: "Sign up for a business account",
      isFullWidth: false
    )
  }
}
