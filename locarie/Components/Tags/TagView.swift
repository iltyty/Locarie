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

  var body: some View {
    Text(tag)
      .foregroundStyle(LocarieColor.greyDark)
      .padding(.vertical, 11.5)
      .padding(.horizontal, 14)
      .background {
        if isSelected {
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(LocarieColor.lightGray)
        } else {
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .strokeBorder(LocarieColor.lightGray, style: .init(lineWidth: 1.5))
        }
      }
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 30
}

#Preview {
  VStack {
    TagView(tag: "test", isSelected: true)
    TagView(tag: "test")
  }
}
