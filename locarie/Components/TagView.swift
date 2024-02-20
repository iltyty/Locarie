//
//  TagView.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct TagView: View {
  let tag: String
  var isSelected: Bool

  init(tag: String, isSelected: Bool) {
    self.tag = tag
    self.isSelected = isSelected
  }

  var body: some View {
    Text(tag)
      .foregroundStyle(isSelected ? Color.locariePrimary : .secondary)
      .padding(.horizontal, Constants.hPadding)
      .padding(.vertical, Constants.vPadding)
      .frame(height: Constants.height)
      .background(background)
  }

  var background: some View {
    RoundedRectangle(cornerRadius: Constants.cornerRadius)
      .fill(.background)
      .stroke(isSelected ? Color.locariePrimary : .secondary)
  }
}

private enum Constants {
  static let height: CGFloat = 40
  static let cornerRadius: CGFloat = 20
  static let hPadding: CGFloat = 10
  static let vPadding: CGFloat = 5
}

#Preview {
  TagView(tag: "test", isSelected: true)
}
