//
//  ProfileAddress.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileAddress: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label {
      addressText
    } icon: {
      Image("BlueMapIcon")
        .resizable()
        .scaledToFit()
        .frame(
          width: ProfileConstants.iconSize,
          height: ProfileConstants.iconSize
        )
    }
  }

  @ViewBuilder
  var addressText: some View {
    let text = user.address
    text.isEmpty
      ? Text("Address").foregroundStyle(.secondary)
      : Text(text)
  }
}
