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
      .foregroundStyle(isSelected ? Color.locariePrimary : .secondary)
      .padding(.horizontal, Constants.hPadding)
      .padding(.vertical, Constants.vPadding)
      .frame(height: height)
      .background(background)
  }

  private var height: CGFloat {
    large ? Constants.largeHeight : Constants.smallHeight
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: Constants.cornerRadius)
      .fill(.background)
      .stroke(isSelected ? Color.locariePrimary : .secondary)
  }
}

private enum Constants {
  static let smallHeight: CGFloat = 24
  static let largeHeight: CGFloat = 40
  static let cornerRadius: CGFloat = 20
  static let hPadding: CGFloat = 10
  static let vPadding: CGFloat = 5
}

#Preview {
  VStack {
    TagView(tag: "test", isSelected: true)
    TagView(tag: "test", large: true)
  }
}
