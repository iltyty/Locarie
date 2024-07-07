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
  var followed = true

  @Binding var isPresentingCover: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 10) {
        if user.profileImageUrls.count == 0 {
          defaultAvatar(size: Constants.size)
        } else {
          KFImage(URL(string: user.profileImageUrls.first ?? ""))
            .placeholder { RoundedAvatarSkeletonView(size: Constants.size) }
            .resizable()
            .scaledToFill()
            .frame(size: Constants.size)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        HStack(alignment: .top) {
          BusinessStatus(user)
          Spacer()
          if followed {
            Image("Bookmark.Fill")
              .resizable()
              .scaledToFill()
              .frame(width: Constants.followedIconWidth, height: Constants.followedIconHeight)
              .foregroundStyle(LocarieColor.primary)
          }
        }
        .padding(.trailing, 16)
      }
      ProfileCategories(user).font(.custom(GlobalConstants.fontName, size: 14))
    }
  }
}

private enum Constants {
  static let size: CGFloat = 72
  static let cornerRadius: CGFloat = 16
  static let followedIconWidth: CGFloat = 12
  static let followedIconHeight: CGFloat = 18
}
