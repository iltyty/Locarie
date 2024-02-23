//
//  BusinessFollowedAvatarRow.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessFollowedAvatarRow: View {
  let user: UserDto

  @Binding var isPresentingCover: Bool

  var body: some View {
    HStack {
      BusinessHomeAvatar(url: user.avatarUrl)
      BusinessStatus(user)
      Spacer()
    }
  }
}
