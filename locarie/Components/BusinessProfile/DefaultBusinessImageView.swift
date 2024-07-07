//
//  DefaultBusinessImageView.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import SwiftUI

struct DefaultBusinessImageView: View {
  var size: CGFloat = Constants.size

  var body: some View {
    Image("DefaultImage")
      .resizable()
      .scaledToFit()
      .frame(size: Constants.iconSize)
      .frame(size: size)
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
