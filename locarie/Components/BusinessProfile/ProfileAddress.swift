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
      Image("Map")
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
    if #available(iOS 17.0, *) {
      text.isEmpty
        ? Text("Address").foregroundStyle(LocarieColor.greyDark)
        : Text(text)
    } else {
      text.isEmpty
        ? Text("Address").foregroundColor(LocarieColor.greyDark)
        : Text(text)
    }
  }
}
