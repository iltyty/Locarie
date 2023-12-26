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
      .background(background)
  }

  var background: some View {
    RoundedRectangle(cornerRadius: Constants.cornerRadius)
      .fill(.background)
      .stroke(isSelected ? Color.locariePrimary : .secondary)
  }
}

private enum Constants {
  static let cornerRadius = 20.0
  static let hPadding = 10.0
  static let vPadding = 5.0
}

#Preview {
  TagView(tag: "test", isSelected: true)
}
