//
//  BusinessProfileAvatarRow.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessProfileAvatarRow: View {
  let user: UserDto

  @Binding var presentingCover: Bool
  @Binding var presentingDetail: Bool

  var body: some View {
    HStack(spacing: 0) {
      BusinessHomeAvatar(url: user.profileImageUrls.first ?? "")
        .onTapGesture {
          presentingCover = true
        }
        .padding(.trailing, 10)
      BusinessStatus(user)
      Spacer()
      BusinessProfileDetailButton(presenting: $presentingDetail)
        .padding(.leading, 10)
        .padding(.trailing, 16)
    }
  }
}
