//
//  ImageDeleteButton.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import SwiftUI

struct ImageDeleteButton: View {
  var body: some View {
    ZStack {
      Circle()
        .fill(.background)
        .frame(width: Constants.size, height: Constants.size)
        .shadow(radius: Constants.shadowRadius)
      Image(systemName: "xmark")
        .font(.system(size: Constants.iconSize))
        .foregroundStyle(.black)
        .frame(width: Constants.iconSize, height: Constants.iconSize)
    }
    .offset(x: Constants.offset, y: -Constants.offset)
  }
}

private enum Constants {
  static let size: CGFloat = 24
  static let iconSize: CGFloat = 12
  static let offset: CGFloat = 5
  static let shadowRadius: CGFloat = 2
}
