//
//  BusinessImageView.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import SwiftUI

struct BusinessImageView: View {
  let url: URL?
  var size: CGFloat = Constants.size
  var bordered: Bool = false

  var body: some View {
    Group {
      AsyncImage(url: url) { image in
        image
          .resizable()
          .scaledToFill()
          .frame(width: size, height: size)
          .clipShape(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
          )
      } placeholder: {
        DefaultBusinessImageView(size: size)
      }
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
