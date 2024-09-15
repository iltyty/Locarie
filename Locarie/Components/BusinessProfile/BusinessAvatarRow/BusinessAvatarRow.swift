//
//  BusinessFollowedAvatarRow.swift
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
    VStack(alignment: .leading, spacing: 16) {
      SquareProfileImages(urls: user.profileImageUrls)
      BusinessStatus(user).padding(.horizontal, 16)
      ProfileCategories(user)
        .font(.custom(GlobalConstants.fontName, size: 14))
        .padding(.horizontal, 16)
    }
  }
  
  static var skeleton: some View {
    VStack(alignment: .leading, spacing: 16) {
      ScrollView(.horizontal) {
        HStack(spacing: 8) {
          ForEach(1..<9, id: \.self) { i in
            RoundedAvatarSkeletonView(size: 128)
          }
        }
      }
      .scrollIndicators(.hidden)
      .scrollDisabled(true)
      VStack(alignment: .leading, spacing: 10) {
        SkeletonView(66, 14)
        SkeletonView(146, 10)
      }
      HStack(spacing: 5) {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
      }
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
