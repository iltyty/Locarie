//
//  BackgroundButtonFormItem.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct BackgroundButtonFormItem: View {
  let title: String
  var isFullWidth: Bool = true
  var isFixedWidth: Bool = false
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
    .background(background)
  }

  private var content: some View {
    Text(title)
      .padding(.horizontal, Constants.textHPadding)
      .fontWeight(.semibold)
      .foregroundStyle(.white)
      .frame(height: FormItemCommonConstants.height)
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
      .fill(color)
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
