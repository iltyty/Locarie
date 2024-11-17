//
//  BusinessImageView.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import Kingfisher
import SwiftUI

struct BusinessImageView: View {
  let url: String
  var data: Data? = nil
  var loadFromData = false
  var size: CGFloat = Constants.size
  var bordered: Bool = false

  var body: some View {
    if loadFromData {
      KFImage.data(data, cacheKey: url)
        .downsampling(size: .init(size: 4 * size))
        .cacheOriginalImage()
        .placeholder { DefaultBusinessImageView(size: size) }
        .resizable()
        .scaledToFill()
        .frame(size: size)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .overlay {
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .strokeBorder(LocarieColor.primary, style: .init(lineWidth: bordered ? Constants.strokeWidth : 0))
        }
    } else {
      KFImage(URL(string: url))
        .placeholder { DefaultBusinessImageView(size: size) }
        .resizable()
        .scaledToFill()
        .frame(size: size)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .overlay {
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .strokeBorder(LocarieColor.primary, style: .init(lineWidth: bordered ? Constants.strokeWidth : 0))
        }
    }
  }
}

private enum Constants {
  static let size: CGFloat = 72
  static let cornerRadius: CGFloat = 16
  static let strokeWidth: CGFloat = 3
}
