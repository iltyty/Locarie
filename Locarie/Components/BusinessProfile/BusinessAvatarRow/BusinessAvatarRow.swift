//
//  BusinessAvatarRow.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import Kingfisher
import SwiftUI

struct BusinessAvatarRow: View {
  let user: UserDto

  @Binding var isPresentingCover: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 10) {
        Group {
          if user.avatarUrl.isEmpty {
            defaultAvatar(size: 34.0, isBusiness: true)
          } else {
            KFImage(URL(string: user.avatarUrl))
              .downsampling(size: .init(size: 68))
              .cacheOriginalImage()
              .placeholder { SkeletonView(34, 34, true) }
              .resizable()
              .frame(size: 34)
              .clipShape(Circle())
          }
        }
        VStack(alignment: .leading, spacing: 2) {
          Text(user.businessName).fontWeight(.bold)
          HStack(spacing: 5) {
            Text(user.neighborhood).foregroundStyle(LocarieColor.greyDark)
              .font(.custom(GlobalConstants.fontName, size: 14))
            DotView()
            Group {
              if user.currentOpeningPeriod == 0 {
                Text("Closed").foregroundStyle(LocarieColor.greyDark)
              } else {
                Text("Open ").foregroundStyle(LocarieColor.green)
              }
            }
            .font(.custom(GlobalConstants.fontName, size: 14))
          }
        }
        Spacer()
      }
      .padding(.bottom, 10)
      .padding(.horizontal, 16)
      SquareProfileImages(urls: user.profileImageUrls).padding(.bottom, 16)
      ProfileCategories(user).font(.custom(GlobalConstants.fontName, size: 14))
        .padding(.horizontal, 16)
    }
  }

  static var skeleton: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 10) {
        SkeletonView(30, 30, true)
        VStack(alignment: .leading, spacing: 10) {
          SkeletonView(60, 10)
          SkeletonView(146, 10)
        }
        Spacer()
      }
      .padding(.bottom, 10)
      SkeletonView(.infinity, 267)
      .padding(.bottom, 16)
      SkeletonView(141, 10)
    }
  }
}

private enum Constants {
  static let size: CGFloat = 72
  static let cornerRadius: CGFloat = 16
}

#Preview {
  BusinessAvatarRow.skeleton
}
