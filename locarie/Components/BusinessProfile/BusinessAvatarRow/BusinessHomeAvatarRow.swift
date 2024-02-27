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

  @Binding var isPresentingDetail: Bool

  var body: some View {
    HStack {
      BusinessHomeAvatar(url: user.avatarUrl, hasUpdates: hasUpdates)
      BusinessStatus(user)
      Spacer()
      BusinessProfileDetailButton(presenting: $isPresentingDetail)
    }
  }
}
