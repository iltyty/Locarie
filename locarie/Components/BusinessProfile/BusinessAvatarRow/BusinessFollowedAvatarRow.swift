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
    HStack {
      AsyncImage(url: URL(string: user.profileImageUrls.first ?? "")) { image in
        image.resizable()
          .scaledToFill()
          .frame(width: Constants.size, height: Constants.size)
          .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
      } placeholder: {
        RoundedAvatarSkeletonView(size: Constants.size)
      }
      VStack(alignment: .leading, spacing: 10) {
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
        ScrollView(.horizontal) {
          ProfileCategories(user).font(.custom(GlobalConstants.fontName, size: 14))
        }
        .scrollIndicators(.hidden)
      }
      .padding(.leading, 16)
    }
    .padding(.leading, 16)
  }
}

private enum Constants {
  static let size: CGFloat = 114
  static let cornerRadius: CGFloat = 16
  static let followedIconWidth: CGFloat = 12
  static let followedIconHeight: CGFloat = 18
}
