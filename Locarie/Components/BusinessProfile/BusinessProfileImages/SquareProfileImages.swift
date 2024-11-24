//
//  SquareProfileImages.swift
//  Locarie
//
//  Created by qiuty on 22/08/2024.
//

import Kingfisher
import SwiftUI

struct SquareProfileImages: View {
  let user: UserDto

  @State private var screenWidth: CGFloat = 0

  var body: some View {
    HStack(spacing: 8) {
      ZStack(alignment: .topTrailing) {
        KFImage(URL(string: user.profileImageUrls[0]))
          .downsampling(size: .init(size: 5 * imageSize))
          .cacheOriginalImage()
          .placeholder {
            DefaultBusinessImageView(size: 2 * imageSize + 8)
          }
          .resizable()
          .scaledToFill()
          .frame(size: 2 * imageSize + 8)
          .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        DistanceView(user: user).padding(5)
      }
      VStack(spacing: 8) {
        imageViewBuilder(1)
        imageViewBuilder(2)
      }
    }
    .frame(maxWidth: .infinity)
    .background {
      GeometryReader { proxy in
        Color.clear.task(id: proxy.size) {
          screenWidth = proxy.size.width
        }
      }
    }
  }

  private var imageSize: CGFloat {
    // 16 for horizontal padding
    // 8 for horizontal padding between images
    // the second 8 for vertical padding between images
    screenWidth > 0 ? (screenWidth - 16 * 2 - 8 - 8) / 3 : 114
  }

  @ViewBuilder
  private func imageViewBuilder(_ i: Int) -> some View {
    if i >= user.profileImageUrls.count {
      DefaultBusinessImageView(size: imageSize)
    } else {
      KFImage(URL(string: user.profileImageUrls[i]))
        .downsampling(size: .init(size: 3 * imageSize))
        .cacheOriginalImage()
        .placeholder {
          DefaultBusinessImageView(size: imageSize)
        }
        .resizable()
        .scaledToFill()
        .frame(size: imageSize)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 16
  static let maxImageCount = 9
}
