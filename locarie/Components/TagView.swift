//
//  TagView.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct TagView: View {
  let tag: Tag

  init(_ tag: Tag) {
    self.tag = tag
  }

  @State var isSelected = false

  var body: some View {
    Text(tag.rawValue)
      .foregroundStyle(isSelected ? Color.locariePrimary : .primary)
      .padding(.horizontal, Constants.hPadding)
      .padding(.vertical, Constants.vPadding)
      .background(background)
      .onTapGesture {
        isSelected.toggle()
      }
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
  TagView(.bar)
}
