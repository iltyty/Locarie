//
//  ProfileDetail.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileDetail: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      ProfileFavoredByCount(user)
      ProfileAddress(user)
      ProfileOpeningHours(user)
      ProfileLink(user)
      ProfilePhone(user)
      Divider()
    }
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16
}
