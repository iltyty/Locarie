//
//  BusinessProfileAvatarRow.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessProfileAvatarRow: View {
  let user: UserDto

  @Binding var isPresentingCover: Bool
  @Binding var isPresentingDetail: Bool

  var body: some View {
    HStack {
      BusinessProfileAvatar(
        url: user.avatarUrl,
        isPresentingCover: $isPresentingCover
      )
      BusinessStatus(user)
      Spacer()
      BusinessProfileDetailButton(presenting: $isPresentingDetail)
    }
  }
}
