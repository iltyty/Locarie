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
    VStack(alignment: .leading, spacing: 16) {
      ProfileFavoredByCount(user)
      ProfileAddress(user)
      ProfileOpeningHours(user)
      ProfileLink(user)
      ProfilePhone(user)
      LocarieDivider()
    }
  }
}
