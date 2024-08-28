//
//  BusinessFollowedAvatarRow.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import Kingfisher
import SwiftUI

struct BusinessFollowedAvatarRow: View {
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
}

private enum Constants {
  static let size: CGFloat = 72
  static let cornerRadius: CGFloat = 16
}
