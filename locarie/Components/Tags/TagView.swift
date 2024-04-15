//
//  TagView.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct TagView: View {
  let tag: String
  var isSelected = false
  var large = false

  var body: some View {
    Text(tag)
      .padding(Constants.textPadding)
      .frame(height: height)
      .background(background)
  }

  private var height: CGFloat {
    large ? Constants.largeHeight : Constants.smallHeight
  }

  @ViewBuilder
  private var background: some View {
    if isSelected {
      selectedBackground
    } else {
      normalBackground
    }
  }

  private var normalBackground: some View {
    RoundedRectangle(cornerRadius: Constants.cornerRadius)
      .stroke(LocarieColor.lightGray)
  }

  private var selectedBackground: some View {
    RoundedRectangle(cornerRadius: Constants.cornerRadius)
      .fill(LocarieColor.lightGray)
  }
}

private enum Constants {
  static let smallHeight: CGFloat = 24
  static let largeHeight: CGFloat = 40
  static let cornerRadius: CGFloat = 20
  static let textPadding: CGFloat = 15
}

#Preview {
  VStack {
    TagView(tag: "test", isSelected: true)
    TagView(tag: "test", large: true)
  }
}
