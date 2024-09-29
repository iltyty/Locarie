//
//  SquareProfileImages.swift
//  Locarie
//
//  Created by qiuty on 22/08/2024.
//

import Kingfisher
import SwiftUI

struct SquareProfileImages: View {
  let urls: [String]

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 8) {
        HStack(spacing: 8) {
          ForEach(urls.indices, id: \.self) { i in
            KFImage(URL(string: urls[i]))
              .downsampling(size: .init(size: 4 * Constants.size))
              .cacheOriginalImage()
              .placeholder {
                DefaultBusinessImageView(size: Constants.size)
              }
              .resizable()
              .scaledToFill()
              .frame(size: Constants.size)
              .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
          }
        }
//        HStack(spacing: 8) {
//          ForEach(0 ..< Constants.maxImageCount - urls.count, id: \.self) { _ in
//            DefaultBusinessImageView(size: Constants.size)
//          }
//        }
      }
      .padding(.horizontal, 16)
    }
    .scrollIndicators(.hidden)
  }
}

private enum Constants {
  static let size: CGFloat = 128
  static let cornerRadius: CGFloat = 16
  static let maxImageCount = 9
}
