//
//  ProfilePhone.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfilePhone: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label {
      phoneText
    } icon: {
      Image(systemName: "phone")
        .font(.system(size: ProfileConstants.iconSize))
        .frame(width: ProfileConstants.iconSize, height: ProfileConstants.iconSize)
    }
  }

  @ViewBuilder
  var phoneText: some View {
    let text = user.phone
    text.isEmpty
      ? Text("Go edit").foregroundStyle(.secondary)
      : Text(text)
  }
}
