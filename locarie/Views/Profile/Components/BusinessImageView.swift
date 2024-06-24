//
//  BusinessImageView.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import Kingfisher
import SwiftUI

struct BusinessImageView: View {
  let url: URL?
  var size: CGFloat = Constants.size
  var bordered: Bool = false

  var body: some View {
    Group {
      KFImage(url)
        .placeholder { DefaultBusinessImageView(size: size) }
        .resizable()
        .scaledToFill()
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    .overlay {
      RoundedRectangle(cornerRadius: Constants.cornerRadius)
        .strokeBorder(LocarieColor.primary, style: .init(lineWidth: bordered ? Constants.strokeWidth : 0))
    }
  }
}

private enum Constants {
  static let size: CGFloat = 72
  static let cornerRadius: CGFloat = 16
  static let strokeWidth: CGFloat = 3
}
