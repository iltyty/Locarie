//
//  BusinessFollowedAvatarRow.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessFollowedAvatarRow: View {
  let user: UserDto
  var followed = true

  @Binding var isPresentingCover: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        AsyncImage(url: URL(string: user.profileImageUrls.first ?? "")) { image in
          image.resizable()
            .scaledToFill()
            .frame(width: Constants.size, height: Constants.size)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        } placeholder: {
          RoundedAvatarSkeletonView(size: Constants.size)
        }
        HStack(alignment: .top) {
          BusinessStatus(user)
          Spacer()
          if followed {
            Image(systemName: "bookmark.fill")
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
