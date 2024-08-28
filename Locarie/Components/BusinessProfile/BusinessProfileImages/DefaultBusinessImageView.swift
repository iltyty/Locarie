//
//  DefaultBusinessImageView.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import SwiftUI

struct DefaultBusinessImageView: View {
  var size: CGFloat
  var width: CGFloat
  var height: CGFloat

  init() {
    size = Constants.size
    width = size
    height = size
  }

  init(size: CGFloat) {
    self.size = size
    width = self.size
    height = self.size
  }

  init(width: CGFloat, height: CGFloat) {
    size = 0
    self.width = width
    self.height = height
  }

  var body: some View {
    Image("DefaultImage")
      .resizable()
      .scaledToFit()
      .frame(size: Constants.iconSize)
      .frame(width: width, height: height)
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(LocarieColor.greyMedium)
      )
  }
}

private enum Constants {
  static let size: CGFloat = 72
  static let iconSize: CGFloat = 28
  static let cornerRadius: CGFloat = 16
}

#Preview {
  DefaultBusinessImageView()
}
