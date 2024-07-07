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
        .fill(.white)
        .frame(size: Constants.size)
        .shadow(radius: Constants.shadowRadius)
      Image(systemName: "xmark")
        .font(.system(size: Constants.iconSize))
        .foregroundStyle(.black)
        .frame(size: Constants.iconSize)
    }
  }
}

private enum Constants {
  static let size: CGFloat = 24
  static let iconSize: CGFloat = 12
  static let shadowRadius: CGFloat = 2
}
