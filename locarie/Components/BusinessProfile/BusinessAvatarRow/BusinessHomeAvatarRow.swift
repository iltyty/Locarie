//
//  BusinessHomeAvatarRow.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessHomeAvatarRow: View {
  let user: UserDto
  let hasUpdates: Bool

  @Binding var presentingCover: Bool
  @Binding var presentingDetail: Bool

  var body: some View {
    HStack(spacing: 10) {
      BusinessHomeAvatar(url: user.profileImageUrls.first ?? "").onTapGesture {
        presentingCover = true
      }
      BusinessStatus(user)
      Spacer()
      BusinessProfileDetailButton(presenting: $presentingDetail)
    }
  }
}
