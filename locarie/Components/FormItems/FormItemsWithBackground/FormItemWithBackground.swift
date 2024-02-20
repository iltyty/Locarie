//
//  FormItemWithBackground.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

struct FormItemWithBackground: View {
  let text: String
  var isFullWidth: Bool = true
  let color: Color = .locariePrimary

  var body: some View {
    Group {
      if isFullWidth {
        content.frame(maxWidth: .infinity)
      } else {
        content
      }
    }
    .background(background)
  }

  private var content: some View {
    Text(text)
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
  static let textHPadding: CGFloat = 48
}

#Preview {
  VStack {
    FormItemWithBackground(text: "Log in")
    FormItemWithBackground(text: "Log in", isFullWidth: false)
    FormItemWithBackground(
      text: "Sign up for a business account",
      isFullWidth: false
    )
  }
}
