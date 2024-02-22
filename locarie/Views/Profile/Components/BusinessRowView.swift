//
//  BusinessRowView.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessRowView: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        avatar
        businessName
      }
      categories
    }
  }
}

private extension BusinessRowView {
  var avatar: some View {
    AvatarView(
      imageUrl: user.avatarUrl,
      size: Constants.avatarSize
    )
  }

  var businessName: some View {
    Text(user.businessName)
      .font(.headline)
      .fontWeight(.bold)
  }

  var categories: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(user.categories, id: \.self) { category in
          TagView(tag: category, isSelected: false)
        }
      }
    }
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 72
}
