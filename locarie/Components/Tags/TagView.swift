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
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .stroke(strokeColor, style: .init(lineWidth: 1.5))
          .padding(0.75)
      }
  }

  private var strokeColor: Color {
    isSelected ? Color(hex: 0x0E0E0E) : LocarieColor.lightGray
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 30
}

#Preview {
  VStack {
    TagView(tag: "Restaurant", isSelected: true)
    TagView(tag: "Bakery")
  }
}
